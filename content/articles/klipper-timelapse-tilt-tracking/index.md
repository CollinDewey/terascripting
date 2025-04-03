---
title: Klipper Timelapse Tilt Tracking with the Logitech QuickCam Orbit
author: Collin Dewey
date: '2025-04-02'
type: Article
slug: klipper-timelapse-tilt-tracking
description: "Using the Logitech QuickCam Orbit to take timelapses of Klipper-based 3D printers with automatic camera tilting"
---

---
## Klipper + Moonraker

There are a few different firmwares for 3D printers to run. A large number of printers use the [Marlin](https://marlinfw.org/) firmware. Marlin runs everything related to printing on the printer itself. You generally will put the 3D print file (gcode) on an SD card, insert it into the printer, and then select the 3D print from a menu attached to the 3D printer. Klipper takes a different approach, offloading a lot of the processing to another computer. This helps with being able to perform some calculations that can improve print quality, such as [input shaping](https://www.youtube.com/watch?v=gzBhTrHv0-c) to make sure the print head doesn't leave ringing. Klipper runs on both the printer and the computer connected to it. But if you want to control the printer from not that computer, you can use one of the many web front-ends for Klipper, such as [Fluidd](https://docs.fluidd.xyz/) and [Mainsail](https://docs.mainsail.xyz/). However, to control Klipper via the web, they all use an application called Moonraker, which performs the bridge from Web to Klipper through implementing a web API. This allows other applications to easily gather information about the state of the printer, and control the printer.

This is how to query the toolhead, which returns something like this in JSON. On the left is the printer before being homed, on the right is after the printer was homed.

`curl http://localhost:7125/printer/objects/query?toolhead`

<table>
<tr>
<th>

```json
{
  "result": {
    "eventtime": 2647.698900775,
    "status": {
      "toolhead": {
        "homed_axes": "",
        "axis_minimum": [
          0.0,
          -3.5,
          -1.0,
          0.0
        ],
        "axis_maximum": [
          246.0,
          241.0,
          255.0,
          0.0
        ],
        "print_time": 9.136092734375,
        "stalls": 0,
        "estimated_print_time": 47.347854765625,
        "extruder": "extruder",
        "position": [
          0.0,
          0.0,
          0.0,
          0.0
        ],
        "max_velocity": 300.0,
        "max_accel": 3800.0,
        "minimum_cruise_ratio": 0.5,
        "square_corner_velocity": 5.0
      }
    }
  }
}
```

</th>
<th>

```json
{
  "result": {
    "eventtime": 2756.441182561,
    "status": {
      "toolhead": {
        "homed_axes": "xyz",
        "axis_minimum": [
          0.0,
          -3.5,
          -1.0,
          0.0
        ],
        "axis_maximum": [
          246.0,
          241.0,
          255.0,
          0.0
        ],
        "print_time": 98.282198921875,
        "stalls": 0,
        "estimated_print_time": 156.090889109375,
        "extruder": "extruder",
        "position": [
          164.5,
          128.5,
          10.0,
          0.0
        ],
        "max_velocity": 300.0,
        "max_accel": 3800.0,
        "minimum_cruise_ratio": 0.5,
        "square_corner_velocity": 5.0
      }
    }
  }
}
```

</th>
</tr>
</table>


---

## Moonraker Timelapse

There's a 3rd party Add-On for Moonraker called Moonraker Timelapse. It's used for just that, creating a timelapse of the progress of your 3D print. You connect a camera to it and when the print reaches a certain command after every layer change, a picture can be taken. When the print is done, all of those pictures can be combined to take a timelapse. They're fun to look at after the print. However the camera position becomes problematic if the print is very tall.

<table>
    <tr>
        <th>
          {{< vid src="timelapse_block.mp4" alt="Timelapse of printing a block" >}}
        </th>
        <th>
          {{< vid src="timelapse_slug.mp4" alt="Timelapse of printing a small slug" >}}
        </th>
    </tr>
</table>

---

## Logitech QuickCam Orbit

Logitech in the past released some spherical cameras for business video conferencing. These cameras are special however, they're motorized to support both pan and tilt. This was intended for face tracking, but we can use that tilting ability to angle the camera up when we want it to.

---

{{< img src="orbit.jpg" alt="Logitech QuickCam Orbit Camera" >}}

---

## Controlling the Camera

To control the camera, we need to access that specific camera. This is generally something like `/dev/video#`, but it's better to access it by its ID since the `/dev/video#` numbers may change across reboots. The camera IDs can be found at `/dev/v4l/by-id/#############`. In my case, my camera is `/dev/v4l/by-id/usb-046d_0994_9CDF88E2-video-index0`.

v4l2-ctl is an application used for controlling Linux cameras. This is often for setting configurations such as brightness, saturation, hue, contrast, white balance, all your favorite camera settings. But for these cameras, there are settings to allow control over pan and tilt. 

To reset the tilt, I can set tilt_reset to true, and the camera will move its motor up and down until it's in a known position. This is required because the motor in these cameras doesn't have any way to reliably know its position, nor reliably set its position.

`v4l2-ctl --device /dev/video0 --set-ctrl=tilt_reset=true`

To move the camera up and down, you set tilt_relative, and it will move the camera position relatively. This can be a positive or negative number.

`v4l2-ctl --device /dev/video0 --set-ctrl=tilt_relative=128`

---

## Scripting the Camera movement

We can combine calls to v4l2-ctl, with our interactions with the Moonraker API. We can't assume the state of the camera, so when the printer homes, lets reset the camera. We can check if the printer's toolhead is homed.

This little bit of Python gets the state of the toolhead
```python
toolhead = requests.get(url="http://localhost:7125/printer/objects/query?toolhead").json()
homed_axes = toolhead['result']['status']['toolhead']['homed_axes']
z_level = toolhead['result']['status']['toolhead']['position'][2]

if (homed_axes == "xyz"):
    print(f"Toolhead homed, Z level is {z_level}")
else:
    print("Toolhead not homed")
```

---

## Code

We need to keep track of the toolhead's state, and reset once whenever the toolhead is not homed. So we need to keep track of a state of the camera being homed, and a state of the toolhead being homed. Because I can't line up the level of the Z axes one to one, I have to hold some sort of camera Z and relate that to the printer Z. After some messing around, I came up with the below.

It loops forever, following these steps:
- Get if the printer is homed, and the Z level of the printer
- If the printer camera is not homed, reset the camera tilt
- When the printer is homed, move the camera up and down depending on the Z axis

```python
import json
import requests
import os
from time import sleep

camera = "/dev/v4l/by-id/usb-046d_0994_9CDF88E2-video-index0" # Device ID
camera_base = 768 # How much the camera needs to be moved after reset for its default position
step_size = 128 # How much to move the camera by each "step"
multiplier = 0.0390625 # Constant to adapt the printer Z to camera Z

cam_z = 0 # Camera Z position
toolhead_homed = False # Is the toolhead homed?
camera_first_home = False # Is the camera homed?

while True:
  # Get the state of the toolhead
  toolhead = requests.get(url="http://localhost:7125/printer/objects/query?toolhead").json()
  toolhead_homed = ['result']['status']['toolhead']['homed_axes'] == "xyz" # Is the printer homed?
  z_level = int(toolhead['result']['status']['toolhead']['position'][2]) # Integer of the Z level

  # If toolhead isn't homed, reset the camera
  if not camera_first_home and not toolhead_homed:
    # Set camera to base position
    os.system(f"v4l2-ctl -d {camera} --set-ctrl=tilt_reset=true")
    sleep(1.6) # Wait for the camera tilt to reset
    os.system(f"v4l2-ctl -d {camera} --set-ctrl=tilt_relative={camera_base}")
    sleep(0.8) # Wait for the camera to move into the base position
    cam_z = 0 # Reset the camera Z to 0
    camera_first_home = True

  # If the toolhead is homed, move the camera one step up or down
  if toolhead_homed:
    camera_first_home = False
    desired_z = int(z_level * multiplier) # Map the printer Z to camera Z
    if (cam_z != desired_z):
      move = 1 if (cam_z - desired_z) > 0 else -1 # Move up or down
      cam_z = cam_z - move # Set camera z
      os.system(f"v4l2-ctl -d {camera} --set-ctrl=tilt_relative={move*step_size}") # Step
  
  # Sleep before next loop
  sleep(0.6)
```

Then I made a simple SystemD unit to have it start moving the camera along with the system
```ini
[Unit]
Description=Moves camera along with 3D Printer

[Service]
Type=simple
Group=video
ExecStart=/usr/bin/python3 camera-mover.py
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

---

## Results

Now when the print toolhead raises, the camera moves up as well

<table>
    <tr>
        <th>
          {{< vid src="timelapse_wobble_tower.mp4" alt="Timelapse of printing a large column" >}}
        </th>
        <th>
          {{< vid src="timelapse_mic_stand.mp4" alt="Timelapse of printing a microphone stand" >}}
        </th>
    </tr>
</table>