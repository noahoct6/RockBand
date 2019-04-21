/* SpriteParser.c - Parses the t files from matlab into an MIF file format
 */

#include <stdio.h>
#include <stdlib.h>

#define INPUT_FILE "audio_files/furelise.wav"			// Input filename
#define OUTPUT_FILE "generated_RAM/furelise.ram"		// Name of file to output to
#define NUM_COLORS 	4								// Total number of different colors
#define WIDTH		8
#define DEPTH		3072

int addr = 0;

int main()
{
	char line[21];
	FILE *in = fopen(INPUT_FILE, "rb");
	FILE *out = fopen(OUTPUT_FILE, "wb");
	size_t num_chars = 20;
	long value = 0;
	int i;
	int *p;
	unsigned int get_size;
	unsigned short check = 10;
	int sample;
	int read;

	if(!in)
	{
		printf("Unable to open input file!");
		return -1;
	}

	while(check != 0x6174){
		fread(&check,1,2,in);
	}

	fread(&get_size,1,4,in);
	unsigned int num_bytes = get_size;
	unsigned int num_samples = num_bytes/4.;

	printf("NumSamples: %i", num_samples);

	fwrite(&num_samples,4,1,out);

	for(i=0;i<num_samples;i++){
		fread(&sample,1,4,in);
		//sample = (sample>>16) & 0x0000FFFF; // left channel
		sample = sample & 0x0000FFFF; // right channel
		//printf("%i\n",sample);
		fwrite(&sample,4,1,out);
	}

	// Get a line, convert it to an integer, and compare it to the palette values.
	// while(fgets(line, num_chars, in) != NULL)
	// {
	// 	value = (char)strtol(line, NULL, 10);
	// 	p = (int *)&value;
	// 	fwrite(p, 2, 1, out);
	// }

	fclose(out);
	fclose(in);
	return 0;
}
