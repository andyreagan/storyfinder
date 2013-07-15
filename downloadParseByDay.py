#!/usr/bin/python

# download zipped tweets by day from Chris's VACC account
#  -unzip them
#  -parse the json
#  -move the text to external drive
#  -delete json

if __name__ == '__main__':
  months=[31,28,31,30,31,30,31,31,30,31,30,31]

  # start with some day, we'll loop over it eventually
  import sys
  month = sys.argv[1]
  year = sys.argv[2]

  days_in_month = months[int(month)-1]
  from pydate import tidy
  days = [tidy(day+1)+'.'+tidy(month)+'.'+tidy(year) for day in range(1,days_in_month)]
  
  print days

  for day in days:
    # download first
    import subprocess
    commanda = 'areagan@REDACTED_HOST:/users/c/d/cdanfort/scratch/twitter/tweet-troll/zipped-raw/'+day+'.tgz'
    commandb = '/Volumes/spaceHog/data'
    subprocess.call(['scp',commanda,commandb])

    # unzip
    subprocess.call('cd /Volumes/spaceHog/data; tar -xvzf '+day+'.tgz',shell=True) # ['tar','-xvzf',commandb+'/'+day+'.tgz']
  
    # create a list of the jsons
    dataroot=commandb+'/'+day+'/'
    json_files = [dataroot + tmp for tmp in subprocess.Popen(['ls',dataroot],stdout = subprocess.PIPE, stderr = subprocess.STDOUT).communicate()[0].rstrip().split('\n')]

    # parse them to text
    import parse_from_to
  
    for json_file in json_files:
      text_file = '/Volumes/spaceHog/data/'+day+'/'+json_file[-19:-5]+'.txt'
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
