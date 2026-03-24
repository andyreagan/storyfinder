#!/usr/bin/python

# clean up all the valence files

vals = ['000','025','050','075','100','125','150','175','200']

def main():
  for val in vals:
    # write the filenames
    tmpin = '../data/Boston_Valence_Seires_' + val + '.txt'
    tmpout = '../data/Boston_Valence_Seires_' + val + '_clean.txt'

    # take the timeseries into a big list
    f = open(tmpin,'r')
    big_list = [[x.rstrip('"').lstrip('"') for x in line.rstrip().split(',')] for line in f]
    f.close()

    # generate the minutes since april field
    for i in range(len(big_list)):
      day,month,year = big_list[i][11].split('.')
      hour = big_list[i][12]
      minute = big_list[i][13]
      total_minutes = int(minute)+60*int(hour)+24*60*int(day)
      big_list[i].append(total_minutes)

    # sort it
    big_list.sort(key=lambda x: int(x[14]))
    
    # remove duplicates, run this thing 10 times
    for j in range(10):
      for i in range(len(big_list)):
        if len(big_list)-2 > i:
          if big_list[i][14] == big_list[i+1][14]:
          # if one is zero, the other isn't...delete the zero
            if float(big_list[i][0]) > 0.1:
              del big_list[i+1]
            else:
              del big_list[i]

    # write out the first num entries of the list to a csv
    num = 11
    g = open(tmpout,'w')
    for i in range(len(big_list)):
      if float(big_list[i][0]) > 0.0:
        tmpstr=''
        for j in range(num):
          tmpstr+=big_list[i][j]+','
        g.write(tmpstr[:-1]+'\n')
    g.close()
    print 'Wrote ' + tmpout

if __name__ == '__main__':
    main()
