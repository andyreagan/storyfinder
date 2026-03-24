# going to parse an hour of the twitter stream, from two hours ago

# print out these things for reference
import sys
#sys.path.append('/users/a/r/areagan/python-modules/')
print '-----------'
print '-----------'
print 'Running in python version:'
print sys.version_info
print '-----------'
import json
print 'json module imported successfully'
print '-----------'

print '-----------'

infile = sys.argv[1]
outfile = sys.argv[2]



  
f = open(infile,'r')

g = open(outfile,'w')

# go line by line in the minute-ly json
for line in f:
  try:   # try to load it
    tweet = json.loads(line)
    if 'delete' not in tweet:
      # check that it's a real tweet (it is)
      try: # try to write it
        tmpstr = str(tweet['coordinates']['coordinates'][1])+','+str(tweet['coordinates']['coordinates'][0])+','+tweet['text'] + '\n'
        g.write(tmpstr)
      except: # record if couldn't write it
        pass
     
  except: # didn't load
    pass

# good housekeeping
f.close()
g.close()

print 'Run success!'
print '-----------'
print '-----------'
