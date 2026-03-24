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

# grab the dates
hour=sys.argv[1]
date=sys.argv[2]
print hour + '.' + date
print '-----------'
print '-----------'

runtime = int(sys.argv[3])

# set up paths to the files in tweet-troll
path_beg = '/users/storyfinder/data/'
files = [date + '/'+'twitter.'+'0'+str(i)+'.'+hour+'.'+date+'.json' if i<10 else date+'/'+'twitter.'+str(i)+'.'+hour+'.'+date+'.json' for i in range(runtime-14,runtime+1)]
dump_files = [date + '/'+'0'+str(i)+'.'+hour+'.'+date+'.txt' if i<10 else date+'/'+str(i)+'.'+hour+'.'+date+'.txt' for i in range(runtime-14,runtime+1)]
big_dump_file = date + '/' + hour + '.' + str(runtime) + '.txt'

# we're going to dump the tweets into day.mon.year/hour.txt
## dump_file = '/users/storyfinder/data/' + date+'/' +hour+'.txt'
## g = open(dump_file,'w')
## dump_file = '/users/storyfinder/data/' + date+'/' +hour+'_geo.txt'
## h = open(dump_file,'w')
## dump_file = '/users/storyfinder/data/' + date+'/' +hour+'_geotxt.txt'
## k = open(dump_file,'w')

# keep track of things
tweet_count=0 # total tweets in the hour

print_errors=0 # couldn't print these guys, though tried

non_en=0 # these were from non-en reported users, don't even try

json_load_errors=0 # couldn't even load a few

delete_request=0 # alot of the data is requests to delete


filename = path_beg + big_dump_file
tmp_big_dump_file = open(filename,'w')

# loop over each minute of tweets
for i in range(15):
  
  filename = path_beg + files[i] #'/.../16.04.13/twitter.59.14.11.03.13.json'
  tmp_file = open(filename,'r')
  
  filename = path_beg + dump_files[i]
  tmp_dump_file = open(filename,'w')
  
  filename = path_beg + big_dump_file

  # go line by line in the minute-ly json
  for line in tmp_file:
    
    # each line is a tweet
    tweet_count+=1  
    
    try:   # try to load it
      
      tweet = json.loads(line)
      
      if 'delete' not in tweet:
        # check that it's a real tweet (it is)
        
        try: # try to find english
          
          if tweet['user']['lang'] == 'en':
            # now we know that it's english
            
            try: # try to write it
              
              tmp_dump_file.write(tweet['text'] + '.\n')
              tmp_big_dump_file.write(tweet['text'] + '.\n')

            except: # record if couldn't write it
              print_errors+=1
          
          else:
            non_en+=1
        
        except:
          print filename + ' failed to have user field'
      else:
        delete_request+=1

    except: # didn't load
      json_load_errors+=1

## stuff for writing out the geo tweets, needs to be within the loaded tweet try

#      try:
#        h.write(str(tweet['coordinates']['coordinates'][1]))
#        h.write(',')
#        h.write(str(tweet['coordinates']['coordinates'][0]))
#        h.write(',')
#        h.write(str(tweet['id']))
#        h.write('\n')
#        k.write(tweet['text'] + '.\n')
#        geo_tweets+=1
#      except:
#        pass
    
  
  # good housekeeping
  tmp_file.close()
  tmp_dump_file.close()

tmp_big_dump_file.close()
# ----- tell me some stuff! ------
print 'Run success!'
## print '-----------'
## 
## print str(tweet_count) + ' total tweets that hour'
## 
## print str(print_errors) + ' tweets errored out printing (lost ' + str(float(print_errors)/float(tweet_count)) + '%)'
## 
## print str(non_en) + ' tweets had users with non-english reported language (tossed' + str(float(non_en)/float(tweet_count)) + '%)'
## 
## print 'there were a total of ' + str(json_load_errors) + ' json loading errors (lost' + str(float(json_load_errors)/float(tweet_count)) + '%)'
## 
## print str(delete_request) + ' tweets were just requests to be deleted (tossed' + str(float(delete_request)/float(tweet_count)) + '%)'
## 
## printed = tweet_count-print_errors-non_en-delete_request
## 
## print 'We printed ' + str(printed) + ' tweets, thats ' + str(float(printed)/float(tweet_count)) + '%'
## 
print '-----------'
print '-----------'
