#!/bin/bash

files=$(ls ./data)

#get the length for each sequence in fasta file(s), keep the name
for file in ${files}
do

awk '/^>/ { # header pattern detected
        if (seqlen){
         # print previous seqlen if exists 
         print seqlen
}

         # pring the tag 
         print

         # initialize sequence
         seqlen = 0

         # skip further processing
         next
      }

# accumulate sequence length
{
seqlen += length($0)
}
# remnant seqlen if exists
END{if(seqlen){print seqlen}}' ./data/$file > lengths.txt

done

#get the longest number
number=$(cut -d: -f 2 lengths.txt | sort -n | tail -n 1)

#get the fasta header corresponding to the number, keep unique, and get rid of ">"; -w option for grep is the length of the longest
test=$(grep -B 1 -w 841 lengths.txt | grep '>' | sort -u | cut -c2-)

#Print the output!
echo "The longest sequence(s) "${test}" is or are "${number}" amino acids long."

#delete temporary file
rm ./lengths.txt
