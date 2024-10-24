---
title: How I create my presentations
author: Collin Dewey
date: '2024-10-24'
type: Article
slug: how-i-create-my-presentations
description: "Creating presentations using the Marp Presentation Ecosystem"
---

---
# Presentation Creation

Occasionally I get asked how I create my presentations that I present to my University's Cyber Defense club. I only get asked this because it's clear I'm not using Powerpoint.

---

# "Normal" Approach

- Microsoft Powerpoint
- Google Sheets

If you're a regular person, you'll most likely create presentations in Microsoft Powerpoint. It's probably the most used presentation creation system in the world (Don't quote me on that). For those who don't want to pay for a license for Powerpoint, there are alternatives such as Google Slides. Both Powerpoint and Slides are great, but I still need to focus on how my textbox is placed, I have to make sure that the font looks good, etc...

---

# Cool Approach

I use Markdown everywhere, I use Markdown in my notes through Obsidian, I use Markdown to create my blog posts using Hugo. Why not use Markdown for my presentations as well?

There's a tool called Marp (Markdown Presentation Ecosystem), which allows me to use Markdown to create presentations.

When you look at my presentations on my website, I link to the slides, as well as display the presentation contents in the blog format. Both of these are generated from the exact[^1] same Markdown file. This means I have to take nearly zero time after my presentation to then post it on my website later on. If I want to convert a post or notes to a slideshow, all I have to do is add some slide separators `---`.

[^1]: The link to the slideshow itself is added to the .md file after I export it to HTML

---

# Exporting

Marp is split into a few different utilities.

- Marp for VS:Code
- Marp CLI
- Marp Core
- Marpit Framework

I personally use Marp's [VS:Code extension](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode). It allows me to view my presentation live while I'm writing it, as well as export the slideshow to many different formats. PDF, HTML, PNG, JPEG, PPTX. HTML provides the most flexibility, and allows me to embed my presentation in a nice format for anyone to view on my website.

[Marp CLI](https://github.com/marp-team/marp-cli) allows exporting the markdown file through the command line. If you're changing a presentation a lot more than I am, you could setup Marp CLI to serve the Markdown files in a presentation format similar to how my website converts Markdown to what you see here.

---

# Directives

Since presentations are quite a different format, Marp provides "directives" to change many parts about the document. A subset is listed below,

Directives[^2]
|Name|Description|
|---|---|
|style|Specify additional CSS|
|theme|Specify theme|
|paginate|Show page number on the slide if you set true|
|header|Specify the content of slide header|
|footer|Specify the content of slide footer|
|class|Specify HTML class of slide’s <section> element|
|color|Setting color style of slide|

These directives are the many ways you have available to style the presentation. I can easily change the theme depending on how I want my pres

[^2]: https://marpit.marp.app/directives

---

# Images

Marp takes the Markdown image syntax and expands it to allow for easy customization within the slideshow.
```
![width:200px height:30cm](image.jpg)
![blur:10px](image.jpg)
![brightness:1.5](image.jpg)
![grayscale:1](image.jpg)
![invert:100%](image.jpg)
![opacity:.5](image.jpg)
```
And for backgrounds...
```
![bg cover](image.jpg)
![bg contain](image.jpg)
![bg fit](image.jpg)
![bg auto](image.jpg)
![bg 50%](image.jpg)
![bg left:50%](image.jpg)
![bg right](image.jpg)
![bg vertical](image.jpg)
```
Multiple backgrounds can be used, which will be auto arranged, although one can change how they are formatted with left, right, and vertical keywords.

---

# HTML

Because Marp allows exporting to HTML, and Markdown allows the inclusion of any HTML elements, I can import custom HTML. I like to integrate websites into my presentations, which is something that you can do within Powerpoint, and here it would just be an iframe. Since I have HTML at my disposal, I can do anything I could do on a website in the slide. Javascript included. This gives me a large amount of flexibility.

---

# Advantages/Disadvantages

You can focus a lot more on the writing itself instead of formatting. It makes moving text between slides easy. It makes including codeblocks easy since there's first-class support for that. I then like to use [asciinema](https://asciinema.org/) to show programs running.

But a lot features normally easy in Powerpoint are somewhat complicated to implement. For example, it's not easy to draw over a slide. 