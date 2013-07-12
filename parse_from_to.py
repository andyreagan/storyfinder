# going to parse an hour of the twitter stream, from two hours ago

def parser(infile,outfile):
  import json

  tmp_file = open(infile,'r')
  tmp_dump_file = open(outfile,'w')

  # go line by line in the minute-ly json
  for line in tmp_file:
    try:   # try to load it
      tweet = json.loads(line)
      if 'delete' not in tweet:
        # check that it's a real tweet (it is)
        try: # try to find english
          if tweet['user']['lang'] == 'en':
            # now we know that it's english
            try: # try to write it
              tmp_dump_file.write(tweet['text'] + '.\n')
            except: # record if couldn't write it
              pass
        except:
          pass 
    except: # didn't load
      pass

  # good housekeeping
  tmp_file.close()
  tmp_dump_file.close()

if __name__ == '__main__':
  # print out these things for reference
  import sys
  #sys.path.append('/users/a/r/areagan/python-modules/')
  print '-----------'
  print '-----------'
  print 'Running in python version:'
  print sys.version_info
  print '-----------'

  infile = sys.argv[1]
  outfile = sys.argv[2]

  parser(infile,outfile)

  print 'Run success!'
  print '-----------'
  print '-----------'
