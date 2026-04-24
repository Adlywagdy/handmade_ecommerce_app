import '../seller_model.dart';

// Mock dashboard stats
const SellerDashboardStats mockDashboardStats = SellerDashboardStats(
  totalSales: '\$32,500',
  totalOrders: '1,240',
  totalRevenue: '\$28,400',
  totalProducts: '45',
  weeklySales: [1200.0, 1800.0, 1400.0, 2200.0, 1900.0, 2500.0, 2100.0],
  monthlySales: [1800.0, 2100.0, 2850.0, 2400.0, 1950.0, 2520.0],
  revenueGrowth: '+12.5%',
  ordersGrowth: '+5.4%',
);

// Mock seller products
List<SellerProductModel> mockSellerProducts = [
  const SellerProductModel(
    id: 'P001',
    name: 'Handmade Ceramic Plate',
    description: 'Beautiful hand-painted ceramic plate with traditional patterns.',
    price: 25.00,
    stock: 15,
    category: 'Ceramics',
    images: ['assets/images/splash.jpeg'],
    isActive: true,
    status: 'In Stock',
  ),
  const SellerProductModel(
    id: 'P002',
    name: 'Woven Cotton Scarf',
    description: 'Soft handwoven cotton scarf with natural dyes.',
    price: 35.00,
    stock: 8,
    category: 'Textiles',
    images: ['assets/images/test.png'],
    isActive: true,
    status: 'In Stock',
  ),
  const SellerProductModel(
    id: 'P003',
    name: 'Wooden Jewelry Box',
    description: 'Hand-carved wooden jewelry box with intricate floral design.',
    price: 45.00,
    stock: 0,
    category: 'Woodwork',
    images: ['assets/images/test2.png'],
    isActive: false,
    status: 'Out of Stock',
  ),
  const SellerProductModel(
    id: 'P004',
    name: 'Hand-Stitched Leather Bag',
    description: 'Premium leather bag with hand-stitched details.',
    price: 89.99,
    stock: 3,
    category: 'Leather',
    images: ['assets/images/splash.jpeg'],
    isActive: true,
    status: 'Low Stock',
  ),
  const SellerProductModel(
    id: 'P005',
    name: 'Terra Cotta Vase',
    description: 'Elegant terra cotta vase with natural matte finish.',
    price: 55.00,
    stock: 22,
    category: 'Ceramics',
    images: ['assets/images/test.png'],
    isActive: true,
    status: 'In Stock',
  ),
  const SellerProductModel(
    id: 'P006',
    name: 'Beaded Bracelet Set',
    description: 'Set of 3 handmade beaded bracelets with natural stones.',
    price: 18.50,
    stock: 40,
    category: 'Jewelry',
    images: ['assets/images/test2.png'],
    isActive: true,
    status: 'In Stock',
  ),
];

// Mock seller orders
List<SellerOrderModel> mockSellerOrders = [
  const SellerOrderModel(
    orderId: '#ORD-12345',
    customerName: 'Sarah Ahmed',
    orderDate: 'Mar 24, 2026',
    totalAmount: 75.00,
    status: 'Pending',
    items: [
      SellerOrderItemModel(productName: 'Handmade Ceramic Plate', quantity: 2, price: 25.00),
      SellerOrderItemModel(productName: 'Terra Cotta Vase', quantity: 1, price: 25.00),
    ],
  ),
  const SellerOrderModel(
    orderId: '#ORD-12346',
    customerName: 'Mohamed Ali',
    orderDate: 'Mar 23, 2026',
    totalAmount: 89.99,
    status: 'Delivered',
    items: [
      SellerOrderItemModel(productName: 'Hand-Stitched Leather Bag', quantity: 1, price: 89.99),
    ],
  ),
  const SellerOrderModel(
    orderId: '#ORD-12347',
    customerName: 'Fatima Hassan',
    orderDate: 'Mar 22, 2026',
    totalAmount: 35.00,
    status: 'Pending',
    items: [
      SellerOrderItemModel(productName: 'Woven Cotton Scarf', quantity: 1, price: 35.00),
    ],
  ),
  const SellerOrderModel(
    orderId: '#ORD-12348',
    customerName: 'Omar Yousef',
    orderDate: 'Mar 21, 2026',
    totalAmount: 55.50,
    status: 'Cancelled',
    items: [
      SellerOrderItemModel(productName: 'Beaded Bracelet Set', quantity: 3, price: 18.50),
    ],
  ),
  const SellerOrderModel(
    orderId: '#ORD-12349',
    customerName: 'Layla Mansour',
    orderDate: 'Mar 20, 2026',
    totalAmount: 45.00,
    status: 'Delivered',
    items: [
      SellerOrderItemModel(productName: 'Wooden Jewelry Box', quantity: 1, price: 45.00),
    ],
  ),
  const SellerOrderModel(
    orderId: '#ORD-12350',
    customerName: 'Khaled Ibrahim',
    orderDate: 'Mar 19, 2026',
    totalAmount: 110.00,
    status: 'Delivered',
    items: [
      SellerOrderItemModel(productName: 'Terra Cotta Vase', quantity: 2, price: 55.00),
    ],
  ),
  const SellerOrderModel(
    orderId: '#ORD-12351',
    customerName: 'Nour El-Din',
    orderDate: 'Mar 18, 2026',
    totalAmount: 25.00,
    status: 'Pending',
    items: [
      SellerOrderItemModel(productName: 'Handmade Ceramic Plate', quantity: 1, price: 25.00),
    ],
  ),
  const SellerOrderModel(
    orderId: '#ORD-12352',
    customerName: 'Amira Saeed',
    orderDate: 'Mar 17, 2026',
    totalAmount: 53.50,
    status: 'Cancelled',
    items: [
      SellerOrderItemModel(productName: 'Beaded Bracelet Set', quantity: 1, price: 18.50),
      SellerOrderItemModel(productName: 'Woven Cotton Scarf', quantity: 1, price: 35.00),
    ],
  ),
];

// Category options for dropdowns
const List<String> sellerCategories = [
  'Ceramics',
  'Textiles',
  'Woodwork',
  'Leather',
  'Jewelry',
  'Pottery',
  'Glasswork',
  'Metalwork',
];
