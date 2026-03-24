#!/usr/bin/python
# goal: subtract time from the input
# written by Andy Reagan
#
# updated 5/10/13 to include minute shifting
#
# USAGE: python pydate.py date min hour day switch
#   date: $(date +%M.%H.%d.%m.%y) e.g. 13.10.10.05.13
#   min: minutes to subtract
#   hour: hours to subtract
#   day: days to subtract
#   switch: either "m","h","d". they return the respective new
#       minute, hour, or hour.day.month
#
# Could eventually write this to go back months, years
# Think I should just subtract them all from the current, then mod

def tidy(tmpint):
  if int(tmpint)<10:
    tmpstr='0'+str(int(tmpint))
  else:
    tmpstr=str(tmpint)
  return tmpstr


if __name__ == '__main__':
  import sys

  # -----get the time and go back two hours ------
  # grab the current time of format $(date +%M.%H.%d.%m.%y)
  
  
  # 4/17/13 generalizing to any hour,day subtraction
  minute,hour,day,month,year = [map(int,sys.argv[1].split('.'))[i] - int(sys.argv[i+2]) for i in range(5)]
  
  # unfortunately we'll need this
  days_in_month=[0,31,28,31,30,31,30,31,31,30,31,30,31]
  # check if it's a leap year, add a day to Feb
  if year in [16,20,24]: #will this code still be running?
    days_in_month[2]+=1
  
  if minute < 0:
    minute+=60
    hour-=1
  
  if hour < 0:
    hour+=24
    day-=1
  
  if day <= 0:
    day+=days_in_month[month-1]
    month-=1
  
  if month <= 0:
    month+=12
    year-=1
  
  
  
  minute,hour,day,month,year=map(tidy,[minute,hour,day,month,year])
  
  if sys.argv[7]=='h':
    print hour
  if sys.argv[7]=='d':
    print day + '.' + month + '.' + year
  if sys.argv[7]=='m':
    print minute
