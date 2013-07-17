#!/usr/bin/python

# download zipped tweets by day from Chris's VACC account
#  -unzip them
#  -parse the json
#  -move the text to external drive
#  -delete json

if __name__ == '__main__':
  # start with some day, we'll loop over it eventually
  import sys
  day = sys.argv[1]

  # download first
  import subprocess
  commanda = '/users/c/d/cdanfort/scratch/twitter/tweet-troll/zipped-raw/'+day+'.tgz'
  commandb = '/users/a/r/areagan/2013/projects/storyfinder/tmp'
  subprocess.call(['cp',commanda,commandb])

  # unzip
  subprocess.call('cd /users/a/r/areagan/2013/projects/storyfinder/tmp; tar -xvzf '+day+'.tgz',shell=True) # ['tar','-xvzf',commandb+'/'+day+'.tgz']

  # create a list of the jsons
  dataroot=commandb+'/'+day+'/'
  json_files = [dataroot + tmp for tmp in subprocess.Popen(['ls',dataroot],stdout = subprocess.PIPE, stderr = subprocess.STDOUT).communicate()[0].rstrip().split('\n')]

  # parse them to text
  import parse_from_to

  for json_file in json_files:
    text_file = '/users/a/r/areagan/2013/projects/storyfinder/tmp/'+day+'/'+json_file[-19:-5]+'.txt'
    print json_file
    print text_file
    parse_from_to.parser(json_file,text_file)

  # delete json
  command = '\\rm '+dataroot+'*.json'
  print command
  subprocess.call(command,shell=True)
  command = '\\rm '+ commandb + '/' + day + '.tgz'
  print command
  subprocess.call(command,shell=True)
