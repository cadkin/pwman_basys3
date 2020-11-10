#!/usr/bin/python3.7

# Convert a 800x600 8 color image into 12-bit COE file for BASYS3 block ram.

import sys, getopt
from PIL import Image
def main():
    # Pretend like this is good option parsing code that wasn't just copied from SO
    ifile = ""
    ofile = ""
    one_bit = False;

    try:
        opts, args = getopt.getopt(sys.argv[1:],"hi:o:1",["ifile=","ofile=","one-bit="])
    except getopt.GetoptError:
        print("Usage: " + sys.argv[0] + ' -i <inputfile> -o <outputfile> [-1]')
        sys.exit(-1)

    for opt, arg in opts:
        if opt == '-h':
            print("Usage: " + sys.argv[0] + ' -i <inputfile> -o <outputfile> [-1]')
            sys.exit(0)
        elif opt in ("-i", "--ifile"):
            ifile = arg
        elif opt in ("-o", "--ofile"):
            ofile = arg
        elif opt in ("-1", "--one-bit"):
            one_bit = True;

    if ifile == "" or ofile == "":
        print("Usage: " + sys.argv[0] + ' -i <inputfile> -o <outputfile> [-1]')
        sys.exit(-1)

    # Do image stuff.
    image = Image.open(ifile)
    pixels = image.load()
    width, height = image.size
    #print(image.mode)
    #image.palette.save("imgp")

    out_file = open(ofile, "w")
    out_str = "memory_initialization_radix = 16;\nmemory_initialization_vector =\n"

    sft = 8
    out24 = 0

    # Convert image to raw data, 1 bit per channel.
    for y in range(height):
        for x in range(width):
            # Get RGB
            rgb = pixels[x, y]
            #print("RGB value: " + str(pixels[x, y]))

            # If image is a one bit image, set all pixels high.
            if (one_bit & rgb):
                rgb = 0b111

            sft -= 1
            out24 |= (rgb << 3 * sft)

            # Collect 3 bytes worth of data and write out.
            if (sft == 0):
                out_str += "{0:0{1}x}".format((out24 >> 12) & 0xfff, 3) + ',\n'
                out_str += "{0:0{1}x}".format((out24) & 0xfff, 3) + ',\n'
                #print("Wrote: " + hex(out24))
                out24 = 0
                sft = 8

    # Backup and write ending semicolon.
    out_file.write(out_str[:-2] + ";")

if __name__ == "__main__":
   main()
