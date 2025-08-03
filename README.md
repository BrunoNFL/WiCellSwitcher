[![en](https://img.shields.io/badge/lang-en-red.svg)](./README.md) [![pt-br](https://img.shields.io/badge/lang-pt--br-green.svg)](./README.pt-BR.md)

<div align="center">
  <img src="https://raw.githubusercontent.com/BrunoNFL/brunonfl.github.io/master/depictions/com.brunonfl.wicellswitcher/icon%403x.png" width="80" alt="WiCellSwitcher Icon">
  <h1>WiCellSwitcher</h1>
</div>


**An intelligent utility for jailbroken iPhones to automatically manage Wi-Fi and Cellular Data for optimal battery life.**

| Key Skills Demonstrated |
| :--- |
| iOS Internals & Reverse Engineering |
| Objective-C & Runtime Manipulation |
| Deep Framework Knowledge (SpringBoard, CoreTelephony) |
| Event-Driven Architecture & Resource Management |
| Problem Solving & Debugging Complex Systems |

---

## The Story: A Personal Problem, A Public Solution

Back in the earlier days of iOS, battery life was a constant battle. I noticed a significant portion of my iPhone's battery drain was due to the radios—specifically, Wi-Fi and Cellular data being active when they weren't needed. The manual process of toggling them was tedious and easy to forget.

I believed there had to be a smarter, automated way. This personal frustration became the motivation for WiCellSwitcher: a tweak born from a real-world problem that aimed to create a "set it and forget it" solution for battery-conscious users. This project is a testament to the idea that if you have a problem, you often have the power to engineer the solution yourself.

## How It Works: A Technical Deep Dive

WiCellSwitcher operates on an **event-driven philosophy**. Instead of inefficiently polling the system's status every few seconds (which would defeat the purpose of saving battery), the tweak intelligently hooks into specific system events, only executing code when a relevant state change occurs.

This was achieved by reverse-engineering iOS frameworks to find the precise, undocumented methods that signal changes in connectivity.

### The Core Logic is built on three key pillars:

1.  **Initial Injection:** The tweak first injects its logic upon the device's startup by hooking into SpringBoard:
    * `%hook SpringBoard` -> `- (void)applicationDidFinishLaunching:(id)application`
    This serves as the main entry point to set up all necessary listeners and initial states.

2.  **Monitoring Wi-Fi State:** To react instantly to Wi-Fi changes (e.g., connecting to a known network or the user manually toggling it), the tweak hooks directly into `SBWiFiManager`:
    * `%hook SBWiFiManager`
        * `- (void)_powerStateDidChange`: Detects when the Wi-Fi radio is turned on or off.
        * `- (void)_linkDidChange`: Detects when the device connects to or disconnects from a Wi-Fi network.

3.  **The Clever Trick - Detecting Cellular Data Changes:** Finding a reliable, private notification for cellular data state changes was a major challenge. The solution was an indirect, but highly effective, one: listen for the UI update event for the status bar icon.
    * `%hook SBStatusBarStateAggregator` -> `- (void)_updateDataNetworkItem`
    This method is called by the system every time the cellular data icon (LTE, 4G, 3G) needs to be refreshed. By hooking this, I could create my own reliable notification and trigger my custom logic, which was neatly injected into the `SBWiFiManager` class to keep the tweak's code self-contained.

## Development Challenges: The Infinite Loop Rite of Passage

No reverse-engineering project is without its struggles. Early iterations of WiCellSwitcher were plagued with lockups and recursive loops, especially when manipulating cellular data.

A classic challenge was creating a situation where:
1. The tweak would disable cellular data.
2. The system would fire a notification about the state change.
3. The tweak would catch this notification and, based on its logic, try to change the state again... ad infinitum.

Debugging these loops—and finding myself temporarily locked out of my own cellular settings—was a crucial part of the development process. It reinforced the importance of careful state management and building checks to prevent the tweak from reacting to its own actions. Overcoming this hurdle was a significant step in making the utility stable and reliable.

## A Gentle Introduction to Tweak Development

For those new to this world, this project was built using the standard tools of the jailbreak community:

* **Theos:** A flexible development toolchain for building tweaks.
* **Logos:** A pre-processing syntax that makes hooking into Objective-C methods incredibly simple and readable (e.g., the `%hook`, `%orig`, and `%end` syntax you see above).
* **Hooking:** The core concept of intercepting a function call (in this case, an Objective-C method) and running your own code before, after, or instead of the original function.

This project is a perfect example of how these tools can be used to extend and modify the functionality of a closed-source operating system like iOS, all to solve a tangible problem.

## Community & Recognition 🏆

WiCellSwitcher was warmly received by the jailbreak community, earning positive feedback and a feature on a major iOS news outlet.

* **Featured on iDownloadBlog:** Read the official review on **[iDownloadBlog](https://www.idownloadblog.com/2019/05/01/wicellswitcher/)**.
* **Original Reddit Release:** See the community's reaction on the **[r/jailbreak subreddit](https://www.reddit.com/r/jailbreak/comments/bjca1y/release_wicellswitcher_switch_between_wifi_and/)**.

### What Users Said

Here are a few comments from the original release thread:

> "THIS is what i need. God i love this. I didnt realize my phone used my cell data when i was connected to wifi. Thats some shit."
>
> — *u/CrucifictionGod on r/jailbreak*

> "Work Perfect in A12 , thanks by this Awesome Tweak!!!"
>
> — *u/yosbel182us on r/jailbreak*

## How to Compile

1.  Ensure you have the [Theos toolchain](https://theos.dev/) installed.
2.  Clone the repository: `git clone https://github.com/BrunoNFL/WiCellSwitcher.git`
3.  Navigate into the project directory: `cd WiCellSwitcher`
4.  Run the make command: `make package`

This will produce a `.deb` file that can be installed on a jailbroken device.
