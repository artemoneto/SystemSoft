import requests
import xlsxwriter
import pandas as pd
import numpy as np

def get_data(url):
    page=pd.read_html(url,encoding='CP1251')
    header=page[6].drop(12).T
    header=header.iloc[1]
    header[0]='Номер УИК'
    data=page[7].drop(12).T
    data.columns=header
    data.reset_index()
    return data

def to_numeric(data):
    data.iloc[:,0]=[int(i.split()[1][1:]) for i in data.iloc[:,0]]
    for i in range(1,12):
        data.iloc[:,i]=pd.to_numeric(data.iloc[:,i])
    for i in range(12,15):
        l=[]
        perc=[]
        for a in data.iloc[:,i]:
            a=a.split()
            l.append(int(a[0]))
            perc.append(float(a[1][:-2]))
        data.iloc[:,i]=l
        data['%% за '+str(data.columns.values[i])]=perc
    return data

url23='http://www.st-petersburg.vybory.izbirkom.ru/region/region/st-petersburg?action=show&tvd=27820001217417&vrn=27820001217413&region=78&global=&sub_region=78&prver=0&pronetvd=null&vibid=27820001217435&type=222'
data=get_data(url23)
data=to_numeric(data)

work = data.iloc[:, [0,1,3,4,12,13,14,15,16,17]]

work['Число избирательных бюллетеней, выданных избирателям'] = work.iloc[:,2:4].sum(axis=1)
work = work.drop(columns=['Число избирательных бюллетеней, выданных избирателям в помещении для голосования в день голосования','Число избирательных бюллетеней, выданных избирателям, проголосовавшим вне помещения для голосования'])

#percentage to people relation
people = work.iloc[:,-1]
total = work.iloc[:,1]
people_perc = round((people / total)*100, 1)

perc1 = work.iloc[:,-4]
perc2 = work.iloc[:,-3]
perc3 = work.iloc[:,-2]

with pd.ExcelWriter('Lab 3.xlsx', engine='xlsxwriter') as writer:
    data.to_excel(writer, sheet_name='Sheet1')
    work.to_excel(writer, sheet_name='Sheet2')
    writer.save()