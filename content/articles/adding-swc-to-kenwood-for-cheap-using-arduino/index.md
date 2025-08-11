---
title: Adding Steering Wheel Controls to a Kenwood Stereo for cheap using an Arduino
author: Collin Dewey
date: '2025-07-26'
lastmod: '2025-07-05'
type: Article
slug: adding-swc-to-kenwood-for-cheap-using-arduino
description: "How to build a DIY steering wheel control interface for a Kenwood stereo using an Arduino through reading resistance-based button inputs and implementing the NEC IR protocol"
---

---

In my 2008 Mazda I use an aftermarket [Kenwood KDC-162U](https://www.kenwood.com/usa/car/caraudio/receivers/kdc-162u/) stereo that was installed by the previous owner. However, they didn't buy the module that allows connecting the car's steering wheel buttons to the stereo to retain button functionality. I see why, these modules are seemingly around $50, which outweighs the inconvenience of not having the buttons. So I went out to make one myself.

---

## Reading button presses from the Steering Wheel Controls

There are multiple ways in which steering wheel controls are implemented. My car has resistance based steering wheel controls, and doesn't communicate to the car's computer. There is a wire that goes from the back of the stereo to the buttons which change the resistance across the wire, back through to the stereo. You'll need to find your car's repair manual and figure out which wires these are. In my case, a Black/White wire and a Brown/Yellow wire. Taking a multimeter to these connections and pressing the buttons, you can watch the resistance change. My car's repair manuals happened to have the acceptable ranges for the resistances on my car.

|Switch position|Resistance (Ω)|
|---|---|
|VOL- button ON|51 - 56|
|VOL+ button ON|140 - 154|
|AUTO SCAN button ON|286 - 315|
|PRESET button ON|534 - 589|
|MODE button ON|985 - 1,080|
|MUTE button ON|1,940 - 2,130|
|OFF|4,800 - 5,290|

Using an Arduino and a resistor, we can create a voltage divider to create a voltage drop depending on what button is being pressed, which we can then read from the Arduino's analog input. This input through the analog to digital converter is a range of 10 bits, so 2^10, or 0-1023. We can check if our reading is within our desire range of resistances with the following formula.

---

<br>
{{< img src="DividerLaTeX.svg" alt="" max-height="7vh" >}}
<!-- \frac{Low\Omega \times 1023}{Low\Omega + 470\Omega} \leq ADC \leq \frac{High\Omega \times 1023}{High\Omega + 470\Omega} -->
<br>
{{< img src="Divider.svg" alt="" >}}
<br>

---
For this, I created a function that runs Arduino's `analogRead` function 100 times, checking the resistance for each button, picking the most common button, and then mapping that to the desired command to send to the stereo.

```C
int hits[7] = {0};

for (int i = 0; i < 100; i++) {
	int value = analogRead(READ_PIN);
	WheelButton button = BUTTON_OPEN;

	if (IN_RANGE_OHM(value, 51, 56)) button = BUTTON_VOLUME_MINUS;
	else if (IN_RANGE_OHM(value, 140, 154)) button = BUTTON_VOLUME_PLUS;
	else if (IN_RANGE_OHM(value, 286, 315)) button = BUTTON_AUTO_SCAN;
	else if (IN_RANGE_OHM(value, 534, 589)) button = BUTTON_PRESET;
	else if (IN_RANGE_OHM(value, 985, 1080)) button = BUTTON_MODE;
	else if (IN_RANGE_OHM(value, 1940, 2130)) button = BUTTON_MUTE;
	else if (IN_RANGE_OHM(value, 4800, 5290)) button = BUTTON_OPEN;

	hits[button]++;
}

switch (most_pressed(hits)) { // Select which button has the most hits
	case BUTTON_VOLUME_MINUS: return CMD_VOLUME_DOWN;
	case BUTTON_VOLUME_PLUS: return CMD_VOLUME_UP;
	case BUTTON_AUTO_SCAN: return CMD_PLAY_PAUSE;
	case BUTTON_PRESET: return CMD_TRACK_NEXT;
	case BUTTON_MODE: return CMD_SORUCE;
	case BUTTON_MUTE: return CMD_MUTE;
	case BUTTON_OPEN: return CMD_NONE;
	default: return CMD_NONE;
}
```

---

## Sending Commands

It surprised me to learn that there's a remote controller for this stereo. Not very practical for the driver or passenger to use, since you'd need to point it at the radio. *Kenwood has given too much power to children in the backseat.*

---

{{< img src="KenwoodRemote.svg" alt="Kenwood RC-406 remote pointed at a Kenwood KDC-162U stereo" >}}

---

Interestingly enough, this IR interface seems to be how Kenwood wants commands to be sent to the radio. In the connector to the unit is an unconnected short Light Blue/Yellow wire labeled the "Steering Wheel Remote Input". On my unit, the stereo holds this wire at 3V which then gets pulled to ground as IR signals are being sent. You can see this while watching the wire's voltage with a multimeter and any pressing buttons on any IR remote. We're going to use this wire to send signals as if we were a remote, implementing the same NEC1 protocol that is used in the remote. All we need to do is pull the signal to ground at the proper times.[^1]

[^1]: This is when you would use a transistor to switch the IR wire to ground when needed. However, I am a computer person and not an electrical person, which means I can ignore proper circuitry practices and everything still works fine anyways.

---

<br>

{{< img src="NEC_New_Message.svg" >}}

<br>

---

Above is a timing diagram for what sending data over NEC looks like. When the diagram signal is high, we'll pull the wire to ground. There's a 9ms high pulse at the start, a low for 4.5ms, and then it starts to send two bytes. Each bit is differentiated by the delay between highs, 1 being longer. One byte is used as an address. This is so different IR devices can avoid triggering each other. Kenwood's address is 0xB9. The second is a byte for whatever command the manufacturer wants. To prevent any corruption, these are sent twice, once normally, and once with the bits flipped.

For this purpose, I made a function named radioWrite just to set the pin to either floating or LOW, and delay a given amount of microseconds. Then I made a function to go through a byte and send each bit with its proper delay on if it's one or zero. The diagram can be seen reflected in the send_command function below.

```C
void send_byte(byte data) {
    double duration = 0;
	for (byte k = 0; k < 8; k++) { // Loop through reading each bit of the byte
		byte bit = bitRead(data, k); 
        if (bit == 1) { duration = 1687.5; } // 1 is a longer delay
        else if (bit == 0 ) { duration = 562.5; }

		radioWrite(LOW, 562.5);
		radioWrite(HIGH, duration); // Duration depends on 0 or 1
	}
}

void send_command_frame(CommandCodes command) {
	// Start frame
	radioWrite(LOW, 9000);
	radioWrite(HIGH, 4500);

	// Send address, address inverse, command, inverse command
	send_byte(0xB9);
	send_byte(~0xB9); // Inverse
	send_byte(command);
	send_byte(~command); // Inverse

	// End of frame
	radioWrite(LOW, 562.5);
	radioWrite(HIGH, 0);
}
```

---

The few different people I found doing this project seemingly didn't implement holding down the button. NEC has a repeat pulse, this way the device can choose what to do with a held button. To do this, I have the program operate on a timer. Every 108ms, the program triggers a function to read the buttons and send the data. It keeps track of the last button sent, so it can send a new message or a repeat pulse depending on what's needed.

---

{{< img src="NEC_All.svg" >}}

---

```C
void repeat_frame() {
    // Start frame
	radioWrite(LOW, 9000);
	radioWrite(HIGH, 2250);

    // End of frame
	radioWrite(LOW, 562.5);
	radioWrite(HIGH, 0);
}
```

---

## Installing

I went with an Arduino Nano. It's small, fast enough for our cases, and I could buy it with a breakout board that has screw terminals so I can avoid soldering anything. It can also run directly off the car's 12V power [^2]. You can find one of these on Aliexpress for a few dollars as long as you're okay with the two week shipping time.

[^2]: Some Arduino Nano units allow for a 6-20V range whereas others cap out at 12V. Get one that does the 20V.

My program can be found on my Github. I tried to make it easy for you to change the commands, buttons, and resistances, for your own purposes.

[Github Gist](https://gist.github.com/CollinDewey/310cc36bc790f73527b0d465719a91e1)

<!--
https://init6.pomorze.pl/projects/kenwood_ford/
https://justinnelsonsprojects.com/swc-arduino/
-->