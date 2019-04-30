#include <stdio.h>
#include <stdlib.h>

#define INPUT_FILE "audio_files/furelise.wav"
#define OUTPUT_FILE "generated_RAM/furelise.ram"

int addr = 0;

// actual sampling frequency is 49300 for audio codec

int main()
{
	FILE *in = fopen(INPUT_FILE, "rb");
	FILE *out = fopen(OUTPUT_FILE, "wb");
	int i;
	unsigned int get_size;
	unsigned short check = 10;
	int sample;

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

	unsigned int zeros = 0;
	num_samples+=294600;//269100;
	fwrite(&num_samples,4,1,out);
	for(i=0;i<294600;i++){
		fwrite(&zeros,4,1,out);
	}

	for(i=0;i<num_samples;i++){
		fread(&sample,1,4,in);
		//sample = (sample>>16) & 0x0000FFFF; // left channel
		sample = sample & 0x0000FFFF; // right channel
		//printf("%i\n",sample);
		fwrite(&sample,4,1,out);
	}

	fclose(out);
	fclose(in);
	return 0;
}
