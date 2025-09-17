
# Uses hyprland's hyprshot as the screenshot taking backend.
# [TODO] make it a nix package

from PIL import Image, ImageGrab
import pytesseract
import subprocess
import pyperclip

SCREENSHOT_CMD = "hyprshot -m region --clipboard-only"


def take_screenshot(cmd=SCREENSHOT_CMD, *args, **kwargs):
    command = cmd.split()
    subprocess.run(command, *args, **kwargs)

def get_image_from_clipboard():
    return ImageGrab.grabclipboard()

def extract_text_from_image(img, copy_to_clipboard=True):
    try:
        text = pytesseract.image_to_string(img)
    except TypeError as e:
        text = ""
        print("No text was found")

    if copy_to_clipboard:
        pyperclip.copy(text)
    return text


def main():
    take_screenshot()
    img = get_image_from_clipboard()
    text = extract_text_from_image(img)
    print(text)


if __name__ == "__main__":
    main()
