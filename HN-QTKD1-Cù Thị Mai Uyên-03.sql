-- Đề 03
-- Phần 1: Thiết kế và khởi tạo CSDL
-- Câu 1. Tạo CSDL và các bảng

create database SalesDB;
use SalesDB;

create table customers(
  customer_id INT primary key auto_increment,
  customer_name VARCHAR(100) not null,
  email VARCHAR(100) not null unique,
  phone VARCHAR(15),
  address VARCHAR(255)
);

create table products(
  product_id INT primary key auto_increment,
  product_name VARCHAR(100) not null,
  price DECIMAL(10, 2) check(price>0),
  category VARCHAR(50)
); 

create table orders(
  order_id INT primary key auto_increment,
  customer_id INT, 
  foreign key(customer_id) references customers(customer_id),
  product_id INT, 
  foreign key(product_id) references products(product_id),
  quantity INT check(quantity>0),
  order_date DATE
); 

-- Câu 2: Thêm dữ liệu
insert into customers(customer_name, email, phone, address)
values ('Nguyen Van An', 'an.nguyen@email.com', '0901111111', 'Ha Noi'),
('Tran Thi Binh', 'binh.tran@email.com', '0902222222', 'TP HCM'),
('Le Van Cuong', 'cuong.le@email.com', '0903333333', 'Da Nang'),
('Pham Thi Dung', 'dung.pham@email.com', '0904444444', 'Ha Noi'),
('Hoang Van Em', 'em.hoang@email.com', '0905555555', 'Can Tho'),
('Do Thi Hoa', 'hoa.do@email.com', '0906666666', 'Hai Phong'),
('Vu Van Giang', 'giang.vu@email.com', '0907777777', 'TP HCM'),
('Bui Thi Hang', 'hang.bui@email.com', '0908888888', 'Ha Noi'),
('Ngo Van Hung', 'hung.ngo@email.com', '0909999999', 'Thanh Hoa'),
('Trinh Thi Khoi', 'khoi.trinh@email.com', '0910000000', 'Nghe An');


insert into products(product_name, price, category)
values ('Laptop Dell XPS', 25000000, 'Dien Tu'),
('iPhone 15 Pro', 30000000, 'Dien Tu'),
('Ao Thun Nam', 200000, 'Thoi Trang'),
('Giay The Thao', 1500000, 'Thoi Trang'),
('Tu Lanh Samsung', 12000000, 'Dien Lanh'),
('May Giat LG', 9000000, 'Dien Lanh'),
('Ban Phim Co', 1500000, 'Phu Kien'),
('Chuot Khong Day', 500000, 'Phu Kien'),
('Noi Com Dien', 800000, 'Gia Dung'),
('Tai Nghe Bluetooth', 2500000, 'Phu Kien');

insert into orders(customer_id, product_id, quantity, order_date)
values (1, 1, 1, '2024-01-10'),
(2, 2, 1, '2024-01-11'),
(3, 3, 5, '2024-01-12'),
(4, 4, 2, '2024-01-13'),
(5, 5, 1, '2024-01-14'),
(6, 6, 1, '2024-01-15'),
(7, 7, 3, '2024-01-16'),
(8, 8, 10, '2024-01-17'),
(9, 9, 2, '2024-01-18'),
(10, 10, 4, '2024-01-19');

-- PHẦN 2: THAO TÁC DỮ LIỆU (DML)
-- Câu 3: Cập nhật dữ liệu
-- 1. Cập nhật giá (price) của sản phẩm "iPhone 15 Pro" thành 32000000.
update products
set price=32000000
where product_name like 'iPhone 15 Pro';
  
-- 2. Cập nhật số lượng (quantity) trong đơn hàng của khách hàng có customer_id = 1 thành 2.
update orders
set quantity=2
where customer_id=1;
set sql_safe_updates=1 ; 

-- Câu 4: Cập nhật dữ liệu
-- Xóa các đơn hàng trong bảng Orders có số lượng (quantity) bằng 10.
delete from orders 
where quantity=10;
 
-- Xóa sản phẩm có tên "Chuot Khong Day" khỏi bảng Products
delete from products
where product_name like 'Chuot Khong Day';  

-- PHẦN 3: TRUY VẤN DỮ LIỆU
-- Câu 5: Truy vấn cơ bản
-- 1. Lấy ra danh sách khách hàng sống tại địa chỉ (address) là "TP HCM".
select * from customers c
where c.address like 'TP HCM'; 

-- 2. Lấy ra danh sách các sản phẩm thuộc danh mục (category) là "Dien Tu".
select * from products p
where p.category like 'Dien Tu';

-- 3. Lấy ra các sản phẩm có giá (price) lớn hơn 10,000,000.
select * from products p
where p.price > 10000000; 

-- 4. Tìm kiếm các khách hàng có tên chứa chữ "Dung".
select * from customers c
where c.customer_name like '%Dung%'; 

-- 5. Lấy ra 5 đơn hàng được đặt gần đây nhất
select * from orders o
order by o.order_date desc
limit 1; 

-- Câu 6: Truy vấn nhiều bảng
-- 1. Lấy ra danh sách gồm: Tên khách hàng (customer_name), Tên sản phẩm (product_name), Số lượng (quantity) và Ngày đặt (order_date).
select c.customer_name, p.product_name, o.quantity, o.order_date
from orders o 
join products p  
on o.product_id=p.product_id 
join customers c
on c.customer_id=o.customer_id; 

-- 2. Lấy ra tên sản phẩm và giá tiền của các đơn hàng mà khách hàng "Nguyen Van An" đã đặt.
select p.product_name, p.price 
from products p
join orders o 
on o.product_id=o.product_id 
join customers c
on o.customer_id=c.customer_id 
where c.customer_name like 'Nguyen Van An'; 

-- 3. Hiển thị tên khách hàng và tổng tiền của đơn hàng (Gợi ý: quantity * price và đặt tên cột là TotalAmount).
select p.product_name, sum(o.quantity * p.price)
as TotalAmount
from products p
join orders o
on p.product_id=o.product_id 
group by p.product_name ;

-- 4. Hiển thị danh sách các sản phẩm chưa có ai đặt hàng
select p.product_name, count(o.quantity)
from products p
join orders o 
on p.product_id=o.product_id 
group by p.product_name 
having count(o.quantity)=0; 

-- Câu 7: Truy vấn gom nhóm
-- 1.Thống kê số lượng khách hàng theo từng tỉnh/thành phố (address).
select c.address, count(c.customer_id)
as address_count
from customers c
group by c.address;

-- 2.Thống kê số lượng sản phẩm có trong mỗi danh mục (category).
select p.category, count(p.product_id)
as category_count 
from products p
group by p.category; 

-- 3.Tìm những tỉnh/thành phố (address) có từ 2 khách hàng trở lên.
select c.address, count(c.customer_id)
from customers c
group by c.address 
having count(c.customer_id) >= 2;

-- Câu 8:Truy vấn lồng 
-- 1.Tìm thông tin những sản phẩm (product_name, price) có giá bán cao nhất cửa hàng.
select p.product_name, p.price 
from (select max(p.price)
as max_price
from products p); 


-- 2.Lấy ra danh sách những khách hàng không mua sản phẩm nào.
select c.customer_name
from (select o.customer_id,count(o.quantity) 
from orders o 
group by o.customer_id 
having count(o.quantity) = 0) 



















