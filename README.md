<img width="1224" height="800" alt="logo_x8" src="https://github.com/user-attachments/assets/17a979b5-0ac8-407b-b124-0e5d919b8900" />

# Pip the Mouse: Desktop Edition
The third Pip the Mouse game! This time, he lives on your desktop while you do stuff. He'll keep you company.

## How to play:
Head to [https://j4y-boi.itch.io/pip-the-mouse-desktop-edition](https://j4y-boi.itch.io/pip-the-mouse-desktop-edition) and download a build.

Once downloaded, launch the application. You can also run the executable via the command line with argument *--fpscounter* to show a FPS counter in the top left corner while playing.

## Features:
- Feeding Pip
- Throwing a ball to Pip
- An autosave system to save your statistics

Yeah, that's about it. 

## Project breakdown:
This project itself was written in GDScript and C# in the Godot engine (Godot 4.7.2 .NET). All the main game physics and mechanics were written in GDScript, while handling window clickthrough was done through C#, the reason for this was that GDScript itself lacked the low-level control needed to modify window properties enough on Windows to add clickthrough to all transparent areas on screen. All the art was drawn by me using Piskel.

## Some screenshots:
<img width="2560" height="1440" alt="Schermopname (19)" src="https://github.com/user-attachments/assets/9f91cb0e-32a3-4ef8-8e7a-ee49be0b3f29" />
<img width="2560" height="1440" alt="Schermopname (20)" src="https://github.com/user-attachments/assets/d44caef8-787a-411a-aeef-4ec041aa72e5" />
<img width="2560" height="1440" alt="Schermopname (23)" src="https://github.com/user-attachments/assets/f064c3ed-92df-4874-80fb-ad58b1397e94" />


## License and thanks
*This project uses code from:
[https://github.com/mbMayer/Godot-Click-Through-Transparent-Window-CSharp](https://github.com/mbMayer/Godot-Click-Through-Transparent-Window-CSharp) for handling clickthrough*

*Pip the Mouse: Desktop Edition by [j4y_boi](https://github.com/j4y-boi) is licensed under [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/)*
