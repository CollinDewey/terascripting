---
title: Making a Light Switch Thermostat
author: Collin Dewey
date: '2022-08-09'
type: Article
slug: light-switch-thermostat
description: "Using a ESP8266 microcontroller and servos to turn on and off a physical light switch based on the ambient temperature"
---

---
# Introduction
---
At some dorms at my University, not every dorm gets its own real thermostat. While some have digital ones, others analog. Some have a light switch that toggles on and off the air conditioning, or the heat. The control between AC and Heat unfortunately is building wide, so this situation leaves you with a few problems.

For example, in the winter...
- If you're too cold, you turn on the light switch to turn on the heat.
- If you're too warm, you turn off the light switch to turn off the heat.

and in the summer...
- If you're too cold, you turn off the light switch to turn off the AC.
- If you're too warm, you turn on the light switch to turn on the AC.

However, this leaves a few problems to be had
- You have to get up, walk to the light switch, every single time you want to adjust the temperature.
- The switch is full blast heat, or full blast cold. No in-between
- You can't control the temperature while you're asleep

Not being able to control the temperature is the huge problem while you're asleep, as it leaves you waking up in a sweat, or shivering. Unfortunately I don't own the building, thus feel uncomfortable actually wiring a real thermostat in. But what if I just made something that would flip the light switch mechanically?

---
# First attempt
---
I knew I would need a few things.
- A thermometer
- A microcontroller
- A servo
- A mount

I looked around online and eventually found a (now deleted) 3D model on thingiverse by carjo3000 which used a little 3D printed bracket and a cheap SG90 servo. I printed it right away on my Makerbot Replicator Mini, which is an older 3D printer that I had on hand at the time.

<table>
	<tr>
		<th>
          {{< img src="LightSwitch1.jpg" alt="3D printed servo mount sitting on a 3D printer build-plate" >}}
		</th>
		<th>
          {{< img src="LightSwitch2.jpg" alt="Servo connected to 3D printed light switch mount" >}}
		</th>
		<th>
          {{< img src="LightSwitch3.jpg" alt="Servo arm connected to 3D Printed handle" >}}
		</th>
	</tr>
</table>

As you can see from the last picture above, I ended up having trouble getting the 3D printed arm to fit the servo arm. This was due to my MakerBot Replicator Mini not being able to correctly Replicate the dimensions of the 3D model. I attempted to super glue the arm, but it would just fall off when attempting to actually flip the switch. Another problem I had with this model is that you had to completely unscrew and re-screw the switch to take on/off the print. This basically meant that if Housing came by, they'd most likely be upset if they saw the thermostat.

---
# Second attempt
---

I figured that if my 3D printer couldn't print the little arm correctly, I'd just use the servo arm that came with the servo, and just use two servos. From my engineering classes at school I was familiar with SOLIDWORKS, so I went online, found a diagram for the dimensions of a light switch, and recreated them in SOLIDWORKS, along with cutouts so the cover could be slid on with only the screws of the light switch loosened. I then created little stands to hold up the servo with a screw hole for them, and physically figured out where I should attach the switch.

<table>
    <tr>
        <th>
          {{< img src="LightSwitch4.jpg" alt="3D printer printing" >}}
        </th>
        <th>
          {{< img src="LightSwitch5.jpg" alt="3D printed light switch mount in two pieces" >}}
        </th>
        <th>
          {{< img src="LightSwitch6.jpg" alt="3D printer printing completed mount" >}}
        </th>
    </tr>
</table>

---
# Hardware
---

After printing and verifying that the servos attached correctly, I had to start working on the hardware sides of things. I ended up using a [TMP102](https://www.sparkfun.com/products/13314) temperature sensor. I had a small breadboard laying around with some adhesive on the back, so I figured I'd use that and stick it to the wall.

{{< img src="LightSwitch7.jpg" alt="Wires connected to a breadboard, connected to a temperature sensor" >}}

I did my testing on an Arduino UNO, but after thinking about it a little more, I decided against using an UNO due to the size of the board. I ended up using a Wemos D1 Mini, which is a ESP8266 board that I ripped from a previous project of mine. Another thing I realized is that I wanted to be able to control the temperature the thermostat was set at, without having to reflash the ESP8266. So I added a potentiometer which would allow me to switch between a range of a few degrees. Thankfully I was able to fit this all on the breadboard I had.

{{< img src="LightSwitch8.jpg" alt="Temperature sensor, potentiometer, servo, and ESP8266 microcontroller connected together using a breadboard" >}}

---
# Software
---
Using the Arduino IDE, I installed the neccisary libraries for flashing my ESP8266, and the library that SparkFun provides for the TMP102. In standard Arduino fashion, there's a run-once section, and a loop section. In the run-once section, which runs when the Arduino starts, I initialize the temperature sensor, initialize the servos, and set the servo positions to the lowered position, out of the way of the switch. Then in the loop section, I read the potentiometer and the thermostat. Then I multiply the % that the potentiometer is at with a specified range of temperatures, and then add that to a base temperature. In my case, I set the base temperature to 66°F, with a temperature range of 8°F. This means that it can be set between 66°F and 74°F, the middle being 70°F. Of course since it's a potentiometer, the number won't be exactly any integer, but that's fine since half a degree off won't change how the room feels much. After getting the desired temperature and the room temperature, I compare them to each other with a temperature tolerance. The tolerance is so the switch isn't being constantly flicked on and off in minor fluctuations of temperature. I personally settled on a tolerance of 1°F. If the thermostat is set to 70°, it'll trigger at 69°. If it is determined that the room is too cold, the servo will turn on the switch, thus the heat will be turned on. Opposite for too warm. I had a deadline so I didn't go further at the time, only heating.

This gave me a pretty promising result for the time. Unfortunately there were a few issues with the project.

<video style="max-height:40vh; aspect-ratio: 1280 / 750;" controls preload="none" poster="LightSwitch9.jpg" alt="Video of 3D printed mount and two servos flicking a light switch on and off"><source src="LightSwitch9.webm"></video>

---
# Problems
---
1) First problem I ran into was getting the switch mounted on the actual dorm light switch. The toggle on the switch was too thick for my 3D printed model. Thankfully that's not that big of a deal, just made the hole in the middle of the model a bit bigger, and now it fits.
2) The way I had initially made the program meant that the thermostat would always be in a mode for heat, so once the dormitory switched to AC, the thermostat would try to make the room a giant Ice Box. Equipped with a little more time, I modified the code to have both a heating and cooling mode.
3) These are cheap little servos, and after the servos are initialized, there would always be a little buzzing sound. It wasn't too loud but you could definitely hear it whenever you walked past it, or if you were particularly quiet. I got around this issue by (software) detaching the servos, and re-attaching it whenever I needed to swing one of the servos. When the servos are attached, it does move a little bit initially, so it's a tiny bit louder when flipping the switch, but the servos are loud enough moving the switch in general that I didn't deem it as that much of a problem.
4) At some point one of the servos decided that it was no longer going to go fast enough to be able to flick the switch. I implemented a variable that would control the speed that the arm moves, thus I was able to mess around with the speed and figure out a compromise of speed/noise that worked.
5) The 3D print was admittedly a bit ugly, and that's mostly down to using my MakerBot Replicator Mini, which had not the greatest print quality. However after the project started I ended up getting an Ender 3 Pro. So I printed a new mount, and after I ended up needing to shrink the holes a little bit, I had a new mount that looked loads cleaner.
6) The adhesive on the breadboard didn't last very long. I tried sticking it up with tape but that too fell. Thankfully the breadboard has two little screw holes in it. After rubbing off the adhesive and extending the mount to have little arms that align to the breadboard holes, I was able to affix the breadboard to the mount.

<table>
    <tr>
        <th>
        	<video style="max-height:40vh; aspect-ratio: 406 / 721;" controls preload="none" poster="LightSwitch10.jpg" alt="The automatic switcher, connected to a real light switch"><source src="LightSwitch10.webm"></video>
        </th>
        <th>
            {{< img src="LightSwitch11.jpg" alt="A newer version of the mount which attaches the breadboard directly to the mount" >}}
        </th>
    </tr>
</table>

---
# Possible Improvements
---

1) Currently, I had to switch between the heating/cooling modes by either serial sending a command, or by changing it in the code and reflashing the device. This is generally because I didn't have enough space on the breadboard to have a button or preferably switch to be able to select the mode.
2) The ESP8266 board is well known for actually having WiFi connectivity. I didn't have time to implement any WiFi features however. Doing so to where you could visit an IP would be much more user friendly, unfortunately the dorm WiFi has certain restrictions that make that hard. It could either host its own access point (which is banned), or be proxied or talk to some external server.
3) The project has no idea on if a person is in the dorm or not. As long as it's on, it's keeping it to the set temperature. A PIR sensor could be added to tell if somebody is in the room, however that's not generally great for a space where people don't travel by the device. Similarly, an ESP32-CAM could be used instead of the ESP8266 that I used, and features like facial detection to preferred temperature could be added, in addition to motion capture. Of course, I could always just not save electricity...

---

## You can see the files mentioned in the article on my [GitHub](https://github.com/CollinDewey/misc/tree/master/light_switch_thermostat)

---

### Edit History:

08/09/22 - Initial Release