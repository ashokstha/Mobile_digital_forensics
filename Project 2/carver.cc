/*-------------------------------------------------------------------------------
* (CS 480-01) (FA18) MOBILE DIGITAL FORENSICS
*                Project 2
*               Submitted By
*           Ashok Kumar Shrestha
*
* Description:
* ============
* Perl script to parse out .JJI (Josh Jones Image) Files from the data files.
*--------------------------------------------------------------------------------*/

#include <stdio.h>
#include <sys/types.h>
#include <sys/dir.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define BUF_SIZE 10

int main(int argc, char **argv){
    
    if(argc<2){
        printf("\n\tUsage: %s (raw image)\n\n", argv[0]);
        return 0;
    }

    //save files in directory jji
    DIR* dir = opendir("ouput_files");
    if (dir){
        // Directory exists. Delete previous files
        system("exec rm -r ouput_files/*");
    }else if (ENOENT == errno){
        // Directory does not exist. Create new Direcotry
        system("exec mkdir ouput_files");
    }else{
        /* opendir() failed for some other reason. */
        printf("Error! Unable to open ouput_files directory. ");
        break;
    }

    /*printf("\nStart processing...\n\n");

    char display[200] = "+-------+------------------------------------+------------+\n";
    printf("%s",display);

	strcpy(display, "|  S.N. |                Hash                |    Size    |\n");
    printf("%s",display);
	
    strcpy(display,"+-------+------------------------------------+------------+\n");
    printf("%s",display); */

    FILE *fptr = fopen(argv[1],"rb");

    //FILE *fptr = fopen("../../jji_project.001","rb");

    unsigned char buf[BUF_SIZE];
    long start_addr, end_addr;
    int count = 0;

    //for each BUF_SIZE chunk of data in image file
    while(fread(buf, BUF_SIZE,1,fptr) > 0){
        // hex value: \x00\x4a\x00\x4f\x00\x53\x00\x48
        
        if(buf[0]== 0x00 && buf[1]== 0x4A && 
        buf[2]== 0x00 && buf[3]== 0x4F && 
        buf[4]== 0x00 && buf[5]== 0x53 && 
        buf[6]== 0x00 && buf[7]== 0x48){
            //save address of start of header
            start_addr = ftell(fptr);
            //printf("START_ADDR: %ld\n", start_addr);

        }else if(buf[0]== 0x00 && buf[1]== 0x4A && 
            buf[2]== 0x00 && buf[3]== 0x4F && 
            buf[4]== 0x00 && buf[5]== 0x4E && 
            buf[6]== 0x00 && buf[7]== 0x45 &&
            buf[8]== 0x00 && buf[9]== 0x53){
                // look for footer... and find address of end of footer,
                end_addr = ftell(fptr);
                //printf("END_ADDR: %ld\n", end_addr);

                long size = end_addr - start_addr;
                char filename[20];
                sprintf(filename,"ouput_files/file_%d.txt",count++);
                
                FILE *foutptr = fopen(filename,"wb");
                //FILE *foutptr = fopen("ouput_files/file.txt","wb");

                fseek(fptr, -10, start_addr);
                fwrite(fptr, 10, 1, foutptr);

                fseek(fptr, end_addr, 0);
                fclose(foutptr);

                char hash[40] = "f6dd6c4877a15e54a7f5172666c921f1";
                printf("| %4d. |  %32s  |  %8ld  |\n",count,hash, size);
                //printf("\n+-------+------------------------------------+------------+\n");
        }else{
            //no match
            fseek(fptr, -(BUF_SIZE - 1), SEEK_CUR);
        }
    }

    //printf("\nNo. of matches: %d\n\n", count);
    fclose(fptr);
    return 0;
}