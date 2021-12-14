 
from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
from datetime import date
from datetime import datetime
from flask import flash
import smtplib

today = date.today()
RESTAURANT_OPEN_TIME=16
RESTAURANT_CLOSE_TIME=22 
colors = [
    "#F7464A", "#46BFBD", "#FDB45C"]
colors1 = [
    "#F7464A", "#46BFBD", "#FDB45C",]
app = Flask(__name__)
  
  
app.secret_key = 'my name is lol'
  
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'restaurant'
  
mysql = MySQL(app)
  
@app.route('/')
@app.route('/login', methods =['GET', 'POST'])
def login():
    msg = ''
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        username = request.form['username']
        password = request.form['password']
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM login_cust WHERE username = % s AND password = % s", (username, password,))
        account=cursor.fetchone()
        cursor.execute("SELECT * FROM chef WHERE username = % s AND password = % s", (username, password,))
        account1=cursor.fetchone()
        cursor.execute("SELECT * FROM manager WHERE username = % s AND password = % s", (username, password,))
        account2=cursor.fetchone()
        if account:
            session['loggedin'] = True
            session['id'] = account[0]
            session['username'] = account[1]
            msg = 'Logged in successfully !'
            cursor.execute("SELECT  * FROM menu")
            data = cursor.fetchall()
            cursor.close()
            return render_template('index.html', students=data)
        elif account2:
            session['loggedin'] = True
            session['id'] = account2[0]
            session['username'] = account2[2]
            cursor.execute("SELECT  * FROM menu")
            data = cursor.fetchall()
            cursor.close()
            return render_template('index3.html', students=data)

        elif account1:
            session['loggedin'] = True
            session['id'] = account1[0]
            session['username'] = account1[2]
            cursor.execute("SELECT  o.id,o.Date, m.Name, o.Status, o.Customerid FROM order1 o, menu m where m.id=o.Menuid and Chefid=%s and o.Date=%s",(session['id'],today))
            data = cursor.fetchall()
            cursor.close()
            return render_template('index8.html', students=data)
        else:
            msg = 'Incorrect username / password !'
    return render_template('login.html', msg = msg)
  
@app.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('username', None)
    cursor = mysql.connection.cursor()
    cursor.execute('truncate table food')
    mysql.connection.commit()
    cursor.close()
    return redirect(url_for('login'))
  
@app.route('/register', methods =['GET', 'POST'])
def register():
    msg = ''
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form and 'email' in request.form and 'name' in request.form and 'date' in request.form and 'phone' in request.form and 'address' in request.form :
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        name = request.form['name']
        phone = request.form['phone']
        dob = request.form['date']
        address = request.form['address']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM login_cust WHERE username = % s', (username, ))
        account = cursor.fetchone()
        cursor.execute("SELECT * FROM login_manager WHERE username = % s ", (username,))
        account1 = cursor.fetchone()
        cursor.execute("SELECT * FROM login_chef WHERE username = % s", (username,))
        account2 = cursor.fetchone()
        if account or account1 or account2:
            msg = 'Account already exists !'
        elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
            msg = 'Invalid email address !'
        elif not re.match(r'[A-Za-z0-9]+', username):
            msg = 'Username must contain only characters and numbers !'
        elif not username or not password or not email:
            msg = 'Please fill out the form !'
        else:
            cursor.execute('INSERT INTO customer VALUES (NULL, % s, % s, % s,%s, %s,%s, %s)', (name,email,address,username, password, dob,phone, ))
            mysql.connection.commit()
            msg = 'You have successfully registered !'
    elif request.method == 'POST':
        msg = 'Please fill out the form !'
    return render_template('register.html', msg = msg)
#@app.route('/logout')
@app.route('/make_reservation', methods=['GET', 'POST'])
def make_reservation():
    cursor = mysql.connection.cursor()
    
    name = request.form['name']
    date = request.form['date']
    time = request.form['from']
    #print(time)
    email = request.form['email']
    date1 = datetime.strptime(date, '%Y-%m-%d')
    date2=datetime.date(date1)
    cursor.execute("select No from reservation where date =%s and time=%s", (date2,time))
    n=cursor.fetchone()
    #print(n)
    #print(date2<today)
    if date2<today:
        flash("You can't make reservations in the past")
    elif n:
        if n[0]==0:
            flash("No reservations left, try another date or time")
        else:
            cursor.execute('INSERT INTO reservation_table VALUES (% s, % s, % s)', (session['id'],date2,time, ))
            mysql.connection.commit()
            cursor.execute('update reservation set No=No-1 where date=%s and time=%s', (date2,time))
            mysql.connection.commit()
            flash('You have successfully registered !' )  
    else:
        flash("the restaurant is not open on that particular day")
        
    cursor.execute('select f.id, m.name, m.price from menu m, food f where m.id=f.Menuid')
    data1 = cursor.fetchall()   
    cursor.execute('select sum(m.price) from menu m, food f where m.id=f.Menuid')
    total=cursor.fetchall()[0]
    cursor.execute("SELECT  * FROM menu")
    data = cursor.fetchall()
    cursor.close()
    return render_template('index.html', students=data, menu=data1, total=total[0])
@app.route('/add_tocart/<string:id_data>', methods=['POST','GET']) 
def add_tocart(id_data):
    flash("Added successfuly to the cart")
    cur = mysql.connection.cursor()
    cur.execute('SELECT id FROM chef  ORDER BY RAND ( )  LIMIT 1')  
    p=cur.fetchone()[0]
    cur.execute("insert into food values(NULL,%s, %s, %s, %s)", (id_data,session['id'], today,p))
    mysql.connection.commit()
    cur.execute('select f.id, m.name, m.price from menu m, food f where m.id=f.Menuid')
    data1 = cur.fetchall()
    cur.execute('select sum(m.price) from menu m, food f where m.id=f.Menuid')
    total=cur.fetchall()[0]
    #print(total[0])
    cur.execute("SELECT  * FROM menu")
    data = cur.fetchall()
    cur.close()
    return render_template('index.html', students=data, menu=data1, total=total[0])

@app.route('/delete1/<string:id_data>', methods = ['GET'])
def delete1(id_data):
    flash("Record Has Been Deleted Successfully")
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM food WHERE id=%s", (id_data,))
    mysql.connection.commit()
    cur.execute('select f.id, m.name, m.price from menu m, food f where m.id=f.Menuid')
    data1 = cur.fetchall()
    cur.execute('select sum(m.price) from menu m, food f where m.id=f.Menuid')
    total=cur.fetchall()[0]
    cur.execute("SELECT  * FROM menu")
    data = cur.fetchall()
    cur.close()
    return render_template('index.html', students=data, menu=data1, total=total[0])
@app.route('/make_order', methods = ['GET','POST'])
def make_order():
    cur = mysql.connection.cursor()
    cur.execute("select Customerid, ReservationDate from reservation_table where Customerid=%s and ReservationDate=%s",(session['id'],today))
    c=cur.fetchall()
    print(c)
    if c:
        try:

            cur.execute("insert into order1 (Customerid, Chefid,Menuid, Date) select f.Customerid, f.chef_id, f.Menuid, f.date from food f")
            #cur.execute("Update order1 set date=%s where Custermerid=%s",(today,session[id]))
            mysql.connection.commit()
        
            cur.execute('insert into bill (total, Customerid, date) select sum(m.price), c.id, f.date from food f, menu m, customer c where m.id=f.Menuid and f.Customerid=c.id ')
            mysql.connection.commit()
            cur.execute('truncate table food')
            mysql.connection.commit()
            #cur.close()

            flash("order has been placed")
        except mysql.connector.Error as error:
            print("Failed to update record to database rollback: {}".format(error))
            # reverting changes because of exception
            cur.rollback()

    else:
        flash("Please register first!")
    cur.execute('select f.id, m.name, m.price from menu m, food f where m.id=f.Menuid')
    data1 = cur.fetchall()
    cur.execute('select sum(m.price) from menu m, food f where m.id=f.Menuid')
    total=cur.fetchall()[0]
    cur.execute("SELECT  * FROM menu")
    data = cur.fetchall()
    cur.close()
    return render_template('index.html', students=data, menu=data1, total=total[0])
@app.route('/update',methods=['POST', 'GET'])
def update():  
      if request.method == 'POST':
        id_data = request.form['id']
        name = request.form['name']
        d = request.form['Description']
        p = request.form['price']
        try:
            flash("Data Updated Successfully")
            cur = mysql.connection.cursor()
            cur.execute("UPDATE menu SET name=%s, Descrpition=%s, price=%s WHERE id=%s", (name, d, p, id_data))
            mysql.connection.commit()
        except mysql.connector.Error as error:
            print("Failed to update record to database rollback: {}".format(error))
            # reverting changes because of exception
            cur.rollback()
        cur.execute("SELECT  * FROM menu")
        data = cur.fetchall()
        cur.close()
        return render_template('index3.html',students=data)
@app.route('/delete/<string:id_data>', methods = ['GET'])
def delete(id_data):
    flash("Record Has Been Deleted Successfully")
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM menu WHERE id=%s", (id_data,))
    mysql.connection.commit()
    cur.execute("SELECT  * FROM menu")
    data = cur.fetchall()
    cur.close()
    return render_template('index3.html', students=data)

@app.route('/insert1', methods = ['POST'])
def insert1():
    
    if request.method == "POST":
  
        name = request.form['name']
        e = request.form['Description']
        p = request.form['phone']
        flash("Data Inserted Successfully")
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO menu (name, Descrpition, price) VALUES (%s, %s, %s)", (name, e, p))
        mysql.connection.commit()
        cur.execute("SELECT  * FROM menu")
        data = cur.fetchall()
        cur.close()
    return render_template('index3.html', students=data)
@app.route('/chefs')
def chefs():
        cur = mysql.connection.cursor()
        cur.execute("SELECT  * FROM chef")
        data = cur.fetchall()
        cur.close()
        return render_template('index4.html', students=data)
@app.route('/menu')
def menu():
        cur = mysql.connection.cursor()
        cur.execute("SELECT  * FROM menu")
        data = cur.fetchall()
        cur.close()
        return render_template('index3.html', students=data)
@app.route('/inventory')
def inventory():
        cur = mysql.connection.cursor()
        cur.execute("SELECT  * FROM inventory")
        data = cur.fetchall()
        cur.close()
        return render_template('index5.html', students=data)
@app.route('/emps')
def emps():
        cur = mysql.connection.cursor()
        cur.execute("SELECT  * FROM employes")
        data = cur.fetchall()
        cur.close()
        return render_template('index6.html', students=data)
@app.route('/res')
def res():
        cur = mysql.connection.cursor()
        cur.execute("SELECT  * FROM reservation")
        data = cur.fetchall()
        cur.close()
        return render_template('index9.html', students=data)
@app.route('/cus')
def cus():
        cur = mysql.connection.cursor()
        cur.execute("SELECT  * FROM customer")
        data = cur.fetchall()
        cur.close()
        return render_template('index10.html', students=data)
@app.route('/res1')
def res1():
        cur = mysql.connection.cursor()
        cur.execute("SELECT  c.name, r.ReservationDate, r.time  FROM customer c, reservation_table r where c.id=r.Customerid and r.ReservationDate=%s",(today,))
        data = cur.fetchall()
        cur.close()
        return render_template('index11.html', students=data)
@app.route('/insert2', methods = ['POST'])
def insert2():
    
    if request.method == "POST":
  
        name = request.form['name']
        e = request.form['email']
        p = request.form['phone']
        username = request.form['username']
        address= request.form['address']
        password = request.form['password']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM login_cust WHERE username = % s', (username, ))
        account = cursor.fetchone()
        cursor.execute("SELECT * FROM login_manager WHERE username = % s ", (username,))
        account1 = cursor.fetchone()
        cursor.execute("SELECT * FROM login_chef WHERE username = % s", (username,))
        account2 = cursor.fetchone()
        if account or account1 or account2:
            flash('Account already exists !')
        elif not re.match(r'[^@]+@[^@]+\.[^@]+', e):
            flash('Invalid email address !')
        elif not re.match(r'[A-Za-z0-9]+', username):
            flash('Username must contain only characters and numbers !')
        elif not username or not password or not e:
            flash('Please fill out the form !')
        else:
            cursor.execute('INSERT INTO chef VALUES (NULL, % s, % s, % s,%s, %s,%s)', (name,username, password,e,address,p, ))
            mysql.connection.commit()
            cursor.close()
            #msg = 'You have successfully registered !'
        #flash("Data Inserted Successfully")
        cur = mysql.connection.cursor()
        cur.execute("SELECT  * FROM chef")
        data = cur.fetchall()
        cur.close()
    return render_template('index4.html', students=data)
@app.route('/update2', methods = ['POST'])
def update2():
    
    if request.method == "POST":
        id=request.form['id']
        name = request.form['name']
        e = request.form['email']
        p = request.form['phone']
        #username = request.form['username']
        address= request.form['address']
        #password = request.form['password']
        flash("Data Inserted Successfully")
        cur = mysql.connection.cursor()
        cur.execute("update  chef  set name=%s, email=%s,address=%s, Phone=%s where id=%s", (name,e,address,p,id))
        mysql.connection.commit()
        cur.execute("SELECT  * FROM chef")
        data = cur.fetchall()
        cur.close()
    return render_template('index4.html', students=data)
@app.route('/delete2/<string:id_data>', methods = ['GET'])
def delete2(id_data):
    flash("Record Has Been Deleted Successfully")
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM chef WHERE id=%s", (id_data,))
    mysql.connection.commit()
    cur.execute("SELECT  * FROM chef")
    data = cur.fetchall()
    cur.close()
    return render_template('index4.html', students=data)
@app.route('/insert3', methods = ['POST'])
def insert3():
    
    if request.method == "POST":
  
        name = request.form['name']
        e = request.form['quantity']
        #p = request.form['phone']
        flash("Data Inserted Successfully")
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO inventory (name, Quanity) VALUES ( %s, %s)", (name, e))
        mysql.connection.commit()
        cur.execute("SELECT  * FROM inventory")
        data = cur.fetchall()
        cur.close()
        return render_template('index5.html', students=data)
@app.route('/delete3/<string:id_data>', methods = ['GET'])
def delete3(id_data):
    flash("Record Has Been Deleted Successfully")
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM inventory WHERE id=%s", (id_data,))
    mysql.connection.commit()
    cur.execute("SELECT  * FROM inventory")
    data = cur.fetchall()
    cur.close()
    return render_template('index5.html', students=data)
@app.route('/update3', methods = ['POST'])
def update3():
    
    if request.method == "POST":
        id=request.form['id']
        name = request.form['name']
        e = request.form['quantity']
        #p = request.form['phone']
        #username = request.form['username']
        #address= request.form['address']
        #password = request.form['password']
        flash("Data Inserted Successfully")
        cur = mysql.connection.cursor()
        cur.execute("update  inventory  set name=%s, Quanity=%s where id=%s", (name,e,id))
        mysql.connection.commit()
        cur.execute("SELECT  * FROM inventory")
        data = cur.fetchall()
        cur.close()
    return render_template('index5.html', students=data)
@app.route('/insert4', methods = ['POST'])
def insert4():
    
    if request.method == "POST":
  
        name = request.form['name']
        e = request.form['address']
        p = request.form['phone']
        flash("Data Inserted Successfully")
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO employes (name, address,phone) VALUES ( %s, %s,%s)", (name, e,p))
        mysql.connection.commit()
        cur.execute("SELECT  * FROM employes")
        data = cur.fetchall()
        cur.close()
        return render_template('index6.html', students=data)
@app.route('/insert9', methods = ['POST'])
def insert9():
    
    if request.method == "POST":
  
        d = request.form['date']
        e = request.form['time']
        p = request.form['slots']
        flash("Data Inserted Successfully")
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO reservation (Date,No, time) VALUES ( %s, %s,%s)", (d,p,e))
        mysql.connection.commit()
        cur.execute("SELECT  * FROM reservation")
        data = cur.fetchall()
        cur.close()
        return render_template('index9.html', students=data)
@app.route('/delete4/<string:id_data>', methods = ['GET'])
def delete4(id_data):
    flash("Record Has Been Deleted Successfully")
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM employes WHERE id=%s", (id_data,))
    mysql.connection.commit()
    cur.execute("SELECT  * FROM employes")
    data = cur.fetchall()
    cur.close()
    return render_template('index6.html', students=data)
@app.route('/delete9/<string:id_data>', methods = ['GET'])
def delete9(id_data):
    flash("Record Has Been Deleted Successfully")
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM reservation WHERE id=%s", (id_data,))
    mysql.connection.commit()
    cur.execute("SELECT  * FROM reservation")
    data = cur.fetchall()
    cur.close()
    return render_template('index9.html', students=data)
@app.route('/update4', methods = ['POST'])
def update4():
    
    if request.method == "POST":
        id=request.form['id']
        name = request.form['name']
        #e = request.form['quantity']
        p = request.form['phone']
        #username = request.form['username']
        address= request.form['address']
        #password = request.form['password']
        flash("Data Inserted Successfully")
        cur = mysql.connection.cursor()
        cur.execute("update  employes  set name=%s, address=%s, phone=%s where id=%s", (name,address,p,id))
        mysql.connection.commit()
        cur.execute("SELECT  * FROM employes")
        data = cur.fetchall()
        cur.close()
    return render_template('index6.html', students=data)
@app.route('/sales')
def sales():
        cur = mysql.connection.cursor()
        cur.execute("SELECT  c.name, m.count1 from max1 m, customer c where m.Customerid=c.id order by count1 desc limit 5 ")
        data1 = cur.fetchall()
        data2=list(data1)
        labels=[a[0] for a in data2]
        values=[a[1] for a in data2]
        #print(values)
        #data2=cur.fetchall()[1]
        cur.execute("SELECT date, sum(total)from bill group by date order by date desc limit 7 ")
        data1 = cur.fetchall()
        data2=list(data1)
        labels1=[a[0] for a in data2]
        values1=[a[1] for a in data2]
        cur.execute("select name, quanity from inventory")
        data3=cur.fetchall()
        data3=list(data3)
        print(data3)
        label2=[a[0] for a in data3]
        item2=[a[1] for a in data3]
        cur.execute('select count(id) from employes')
        label3=['Employees','Chefs','Manager']
        data4=cur.fetchall()
        item3=[]
        item3.append(data4[0][0])
        cur.execute('select count(id) from chef')
        data4=cur.fetchall()
        print(data4)
        item3.append(data4[0][0])
        cur.execute('select count(id) from manager ')
        data4=cur.fetchall()
        item3.append(data4[0][0])
        cur.execute('select m.name,count(o.Menuid) from menu m, order1 o where m.id=o.Menuid group by o.Menuid')
        data5=cur.fetchall()
        data5=list(data5)
        labels4=[a[0] for a in data5]
        values4=[a[1] for a in data5]
        #print(item3)
        cur.close()
        return render_template('index7.html', title='Top 5 frequent customers',title1='Daily sales',title2='Inventory quantity of each item' ,title3='Manager vs employees vs Chefs',title4='No. of times each menu is ordered',labels1=labels1, labels=labels,values=values,values1=values1,labels4=labels4,values4=values4,max=50, max1=500,set=zip(item2, label2),set1=zip(item3,label3,colors1) )

@app.route('/update5', methods = ['POST'])
def update5():
    
    if request.method == "POST":
        id=request.form['id']
        name = request.form['name']
        e = request.form['from']
        #p = request.form['phone']
        #username = request.form['username']
        #address= request.form['address']
        #password = request.form['password']
        flash("Data Inserted Successfully")
        cur = mysql.connection.cursor()
        cur.execute("update  order1  set  status=%s where id=%s", (e,id))
        mysql.connection.commit()
        cur.execute("SELECT  o.id,o.Date, m.name, o.status, o.Customerid FROM order1 o, menu m where m.id=o.Menuid and Chefid=%s and o.Date=%s",(session['id'],today,))
        data = cur.fetchall()
        cur.close()
        return render_template('index8.html', students=data)
@app.route('/update9', methods = ['POST'])
def update9():
    
    if request.method == "POST":
        id=request.form['id']
        d = request.form['date']
        s = request.form['time']
        t = request.form['slots']
        #username = request.form['username']
        #address= request.form['address']
        #password = request.form['password']
        flash("Data Inserted Successfully")
        cur = mysql.connection.cursor()
        cur.execute("update  reservation  set Date=%s, No=%s, time=%s where id=%s", (d,s,t,id))
        mysql.connection.commit()
        cur.execute("SELECT  * FROM reservation")
        data = cur.fetchall()
        cur.close()
    return render_template('index9.html', students=data)
if __name__ == '__main__':
    app.run(debug=True)
 