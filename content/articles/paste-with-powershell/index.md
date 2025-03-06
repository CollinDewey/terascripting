---
title: Pasting in Paste Restricted Locations on Windows with PowerShell
author: Collin Dewey
date: '2025-03-05'
lastmod: '2025-03-05'
type: Article
slug: paste-with-powershell
description: "Using PowerShell to bypass paste restrictions in applications by simulating keyboard inputs with a single command. No additional software required."
---

When you copy text, that goes into a temporary space called the clipboard. When you paste, it dumps the contents from that clipboard. Copy and Paste help speed up tasks all the time, but some applications don't want you to be able to paste. This could be pasting into text fields online (Retype your email/password), or pasting text into an online virtual machine that doesn't have that ability.

---
## TL;DR

Open the Run dialog box by pressing Win+R, and paste this in. It will stay in the Run dialog for future invocations. When you run it, quickly select your desired application and watch the contents of your clipboard be pasted letter by letter to whatever application you're using.
```
powershell -w hidden -c "sleep 2;Add-Type -A System.Windows.Forms;[Windows.Forms.SendKeys]::SendWait(((Get-Clipboard -Raw) -replace '`r`n','`n' -replace '[+^%~(){}\[\]]','{$0}'))"
```

<video style="max-height:40vh; aspect-ratio: 738 / 641;" controls preload="none" poster="paste.webp" alt="A preview of copying some text, opening the Windows Run dialog, running the line of PowerShell, and pasting the clipboard's contents to a selected window"><source src="paste.webm"></video>

---
## Existing approaches

There are many approaches that can be taken to type out the characters in your clipboard character by character. Such as...

|Name|Description|
|---|---|
|[AutoHotKey](https://www.autohotkey.com/)| `^+v::SendRaw %clipboard%` Scripting language for task automation|
|[ClickPaste](https://github.com/Collective-Software/ClickPaste)|GUI application for pasting text as keystrokes|
|[noVNCCopyPasteProxmox](https://gist.github.com/amunchet/4cfaf0274f3d238946f9f8f94fa9ee02)|Tampermonkey script for pasting into specifically Proxmox|

Of these options, AutoHotKey is the simplest method. ClickPaste has the easiest granular control, letting you decide the delay between key presses. But they all require downloading something to the computer you're using. If you're using some sort of lab computer where you don't have access to the outside internet, or don't have permission to download files, you're out of luck with those tools. But there are some parts of Windows we can take advantage of.

---
## Requirements

I wanted a solution to this problem which followed a few requirements
- Didn't require downloading anything off of the Internet
- Command would fit in the Windows Run dialog (259 Characters)
- Use the Clipboard as input
- Works with normal text (Not files or binaries)
- Acts like a keyboard and types out character by character
- Works on Windows 10/11

---
## System.Windows.Forms.SendKeys
Looking up scripts on how to paste your clipboard with PowerShell, you'll find scripts that use .NET, which has a [SendKeys](https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.sendkeys) class, used for sending characters, one by one, to a window.


Here's an example that loads Windows.Forms.SendKeys, waits two seconds, and types out "Hello".
```powershell
# Wait 2 seconds, type out "Hello"
Start-Sleep -Seconds 2
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('Hello')
```

---
## Get-Clipboard and Replace

But we want to use the contents of our clipboard.

In PowerShell, getting the contents from the user's clipboard is very easy,
```powershell
# Types out the contents of the clipboard to the screen (One line)
Start-Sleep -Seconds 2
$clipboard = Get-Clipboard
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait($clipboard)
```

Which works! However if we try to copy more than one line, we get an exception.

```
Exception calling "SendWait" with "1" argument(s): "Specified repeat count is not valid."
At line:5 char:1
+ [System.Windows.Forms.SendKeys]::SendWait($clipboard)
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [], MethodInvocationException
    + FullyQualifiedErrorId : ArgumentException
```

Get-Clipboard does support multiline text, but it adds each line to an array of strings instead of one. The `-Raw` argument outputs the entire clipboard as a continuous string. But even then we will run into the same error.

We need to sanitize the inputs to avoid running into the special codes that SendKeys uses. We can replace characters with PowerShell's [replace](https://ss64.com/ps/replace.html) functionality. We have to do this with the newlines, since Windows stores newlines in the clipboard as a carriage return and a newline (\r\n), but SendKeys expects just a newline (\n). PowerShell uses \` for its escape character instead of \\.


```powershell
# Replaces \r\n with \n
$clipboard_newline = $clipboard -replace '`r`n', '`n'
```

Now running SendKeys, it can write out multiple lines, but it still fails if we don't deal with the other special characters that SendKeys uses.

SendKeys has a bunch of command codes surrounded by braces. These are useful for scripts manipulating the keyboard, but much less useful for trying to copy paste regular text.
These are just a subset of the codes provided by SendKeys.

|Key|Code|
|---|---|
| BACKSPACE | {BACKSPACE}, {BS}, {BKSP} |
| DEL or DELETE | {DELETE} or {DEL} |
| ENTER | {ENTER} or ~ |
| INS or INSERT | {INSERT} or {INS} |
| NUM LOCK | {NUMLOCK} |
| CAPS LOCK | {CAPSLOCK} |
| TAB | {TAB} |
| F# | {F1} {F2} {F3}... |
| SHIFT | + |
| CTRL | ^ |
| ALT | % |


From Microsoft's SendKeys documentation, we must sanitize `+`,`^`,`%`,`~`,`()`,`{}`, and `[]`
> The plus sign (+), caret (^), percent sign (%), tilde (~), and parentheses () have special meanings to SendKeys. To specify one of these characters, enclose it within braces ({}). For example, to specify the plus sign, use "{+}". To specify brace characters, use "{{}" and "{}}". Brackets ([ ]) have no special meaning to SendKeys, but you must enclose them in braces.


Replaces the set of special characters with itself surrounded with a curly brace.
```powershell
$clipboard_newline_escaped = $clipboard_newline -replace '[+^%~(){}\[\]]', '{$0}'
```

These two replacments are enough to copy whatever you want, as long as it isn't a file or weird unicode characters.

---
## Running PowerShell

PowerShell supports commands as an argument through two ways. Through `-Command` and through `-EncodedCommand`.
Unfortunately, the encoded command must be a UTF-16LE formatted string. I think it's pretty clear which method is better for our usecase of fitting it into the Run dialog.

```sh
powershell -Command "Write-Host Hello"
powershell -EncodedCommand VwByAGkAdABlAC0ASABvAHMAdAAgAEgAZQBsAGwAbwAhAA==
```

We also want our newly spawned Window to be hidden so we can select on what we want to paste into, and PowerShell has that as the `-WindowStyle` argument. This will open and hide the new window. Although I wouldn't advise using this for `Write-Host`.

```sh
powershell -WindowStyle hidden -Command "Write-Host Hello"
```


---
## Bringing it together

All together, we have this, which is to be invoked with `powershell -WindowStyle hidden -Command`

```powershell
Start-Sleep -Seconds 2
Add-Type -AssemblyName System.Windows.Forms
$clipboard = Get-Clipboard -Raw
$clipboard_newline = $clipboard -replace '`r`n','`n'
$clipboard_newline_escaped = $clipboard_newline -replace '[+^%~(){}\[\]]', '{$0}'
[System.Windows.Forms.SendKeys]::SendWait($clipboard_newline_escaped)
```

But it can be made shorter. First we can collapse the replacments into one long line.

```powershell
Start-Sleep -Seconds 2
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait(((Get-Clipboard -Raw) -replace '`r`n', '`n' -replace '[+^%~(){}\[\]]', '{$0}'))
```

Then there's a few things we can substitute with shorter commands/arguments.
|Initial|New|
|---|---|
|Add-Type -AssemblyName|Add-Type -A|
|Start-Sleep -Seconds|sleep|
|System.Windows.Forms.SendKeys|Windows.Forms.SendKeys|
|powershell -Command|powershell -c|
|powershell -WindowStyle|powershell -w|

```powershell
sleep 2
Add-Type -A System.Windows.Forms
[Windows.Forms.SendKeys]::SendWait(((Get-Clipboard -Raw) -replace '`r`n', '`n' -replace '[+^%~(){}\[\]]', '{$0}'))
```
We can put all of that onto one line with semicolons, remove excess space, and that gives us
```powershell
sleep 2;Add-Type -A System.Windows.Forms;[Windows.Forms.SendKeys]::SendWait(((Get-Clipboard -Raw) -replace '`r`n','`n' -replace '[+^%~(){}\[\]]','{$0}'))
```
Add the call to PowerShell for running from the Run dialog
```batch
powershell -w hidden -c "sleep 2;Add-Type -A System.Windows.Forms;[Windows.Forms.SendKeys]::SendWait(((Get-Clipboard -Raw) -replace '`r`n','`n' -replace '[+^%~(){}\[\]]','{$0}'))"
```
Which fits all of the requirements I had set. It's even short enough that you could reasonably put it on a sticky note.