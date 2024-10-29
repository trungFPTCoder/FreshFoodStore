<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="dto.OrderDTO" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="dal.OrdersDAO"%>
<%@page import="model.Orders"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../css/bootstrap.css">
    <link rel="stylesheet" href="../css/adminCss/Orders.css">
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" href="../admin/HeadSidebar/header-sidebar.css">
    <title>Orders</title>
</head>

<body>
    <%@include file="HeadSidebar/sidebar.jsp" %> 
    <%@include file="HeadSidebar/header.jsp" %>
    <div class="scale-container">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-2 bg-Secondary text-white">
                    <div id="sidebar-container"></div>
                </div>
                <div class="col-md-10 bg-Secondary text-white">
                    <div id="header-container">
                        <div class="row mt-4">
                            <div class="col-md-12">
                                <div class="card text-dark bg-light d-flex mb-3">
                                    <h4 class="card-header bg-light" style="font-weight: bold;">Tổng quan đơn hàng</h4>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-3" style="border-right: 3px solid #F0F1F3;">
                                                <h5 class="card-title" style="color:#1570EF;">Tổng số đơn hàng</h5>
                                                <div class="d-flex justify-content-between">
                                                    <p class="card-text">
                                                        <c:choose>
                                                            <c:when test="${not empty orderOverview}">
                                                                <c:out value="${orderOverview['totalOrders']}" />
                                                            </c:when>
                                                            <c:otherwise>0</c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                                <div class="d-flex justify-content-between">
                                                    <p class="card-text">Last 7 days</p>
                                                    <p class="card-text">Order</p>
                                                </div>
                                            </div>

                                            <div class="col-md-3" style="border-right: 3px solid #F0F1F3;">
                                                <h5 class="card-title" style="color:#E19133;">Tổng tiền nhận được</h5>
                                                <div class="d-flex justify-content-between">
                                                    <p class="card-text">
                                                        <c:choose>
                                                            <c:when test="${not empty orderOverview}">
                                                                <fmt:formatNumber value="${orderOverview['totalRevenue']}" type="currency" currencySymbol="₫" />
                                                            </c:when>
                                                            <c:otherwise>0</c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                                <div class="d-flex justify-content-between">
                                                    <p class="card-text">Last 7 days</p>
                                                    <p class="card-text">Revenue</p>
                                                </div>
                                            </div>

                                            <div class="col-md-3" style="border-right: 3px solid #F0F1F3;">
                                                <h5 class="card-title" style="color:#845EBC">Đang vận chuyển</h5>
                                                <div class="d-flex justify-content-between">
                                                    <p class="card-text">
                                                        <c:choose>
                                                            <c:when test="${not empty orderOverview}">
                                                                <c:out value="${orderOverview['totalShipping']}" />
                                                            </c:when>
                                                            <c:otherwise>0</c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                                <div class="d-flex justify-content-between">
                                                    <p class="card-text">Last 7 days</p>
                                                    <p class="card-text">Order</p>
                                                </div>
                                            </div>

                                            <div class="col-md-3">
                                                <h5 class="card-title" style="color:#F36960">Chưa vận chuyển</h5>
                                                <div class="d-flex justify-content-between">
                                                    <p class="card-text">
                                                        <c:choose>
                                                            <c:when test="${not empty orderOverview}">
                                                                <c:out value="${orderOverview['totalWaiting']}" />
                                                            </c:when>
                                                            <c:otherwise>0</c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                                <div class="d-flex justify-content-between">
                                                    <p class="card-text">Last 7 days</p>
                                                    <p class="card-text">Order</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="card text-dark bg-light d-flex mb-3">
                                    <div class="card-header bg-light d-flex align-items-center justify-content-between">
                                        <h4 class="mb-0" style="font-weight: bold;">Đơn hàng</h4>
                                        <div>
                                            <button class="btn btn-sm btn-outline-secondary"style="width: 105px;">Bộ lọc</button>
                                            <button class="btn btn-sm btn-outline-secondary"style="width: 105px;">Lịch sử đơn hàng</button>
                                        </div>
                                    </div>

                                    <!-- Pagination logic -->
                                    <div class="card-body" style="height: auto">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th scope="col">ID</th>
                                                    <th scope="col">Tên khách hàng</th>
                                                    <th scope="col">Thanh toán</th>
                                                    <th scope="col">Tổng giá trị</th>
                                                    <th scope="col">Ngày đặt</th>
                                                    <th scope="col">Người giao đơn</th>
                                                    <th scope="col">Trạng thái đơn hàng</th>
                                                    <th scope="col"></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            
                                                <c:forEach var="order" items="${orderDisplayList}">
                                                   <form id="infoForm2_${order.orderId}" action="OrdersController?action=viewOrderDetail" method="POST">
                                                    <tr onclick="document.getElementById('infoForm2_${order.orderId}').submit();" style="cursor: pointer;">
                                                        <td>${order.orderId}</td>
                                                        <td>${order.receiverName}</td>
                                                        <td>${order.paymentStatus}</td>
                                                        <td><fmt:formatNumber value="${order.totalPrice}" pattern="#,###" /></td>
                                                        <td>${order.orderCreatedAt}</td>    
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${empty order.shipperName}">
                                                                    <span style="color:red;">Chưa có</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${order.shipperName}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>${order.deliveryStatus}</td>
                                                        <td>
                                                            <input type="hidden" name="currentId" value="${order.orderId}"/>    <%-- id order cần xem detail --%>
                                                            <button class="btn btn-sm btn-outline-primary" type="submit">
                                                                <ion-icon name="pencil-outline"/>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                   </form>
                                                </c:forEach>
                                                <c:if test="${empty orderDisplayList}">
                                                    <tr>
                                                        <td colspan="8" class="text-center">Không có đơn hàng nào</td>
                                                    </tr>
                                                </c:if>
                                            
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Pagination buttons -->
                                    <div class="card-footer d-flex justify-content-between"
                                         style="bottom: 0; background-color: white;">
                                        <button class="btn btn-outline-secondary" id="prevPage" style="width: 100px;">Previous</button>
                                        <span class="mx-3" id="pageInfo"></span>
                                        <button class="btn btn-outline-secondary" id="nextPage" style="width: 100px;">Next</button>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <script src="../js/bootstrap.js"></script>
    <script src="../admin/HeadSidebar/MenuButton.js"></script>
    <script src="../admin/HeadSidebar/SideBar.js"></script>

    <!-- JavaScript to handle pagination -->
    <script>
// Dữ liệu sẽ được hiển thị trong bảng
                                                            let table = document.querySelector('table tbody');
                                                            let rows = table.querySelectorAll('tr');
                                                            let rowsPerPage = 8; // Số hàng hiển thị trên mỗi trang
                                                            let currentPage = 1; // Trang hiện tại
                                                            let totalPages = Math.ceil(rows.length / rowsPerPage); // Tổng số trang

// Hàm hiển thị hàng theo trang
                                                            function displayTablePage(page) {
                                                                // Tính toán chỉ mục bắt đầu và kết thúc
                                                                let start = (page - 1) * rowsPerPage;
                                                                let end = start + rowsPerPage;

                                                                // Ẩn tất cả các hàng trước
                                                                rows.forEach((row, index) => {
                                                                    row.style.display = (index >= start && index < end) ? '' : 'none';
                                                                });

                                                                // Cập nhật trạng thái nút phân trang
                                                                document.getElementById('prevPage').disabled = (page === 1);
                                                                document.getElementById('nextPage').disabled = (page === totalPages);

                                                                // Cập nhật số trang hiển thị
                                                                document.getElementById('pageInfo').innerText = `Page ${page} of ${totalPages}`;
                                                            }

// Hàm chuyển sang trang trước
                                                            function prevPage() {
                                                                if (currentPage > 1) {
                                                                    currentPage--;
                                                                    displayTablePage(currentPage);
                                                                }
                                                            }

// Hàm chuyển sang trang tiếp theo
                                                            function nextPage() {
                                                                if (currentPage < totalPages) {
                                                                    currentPage++;
                                                                    displayTablePage(currentPage);
                                                                }
                                                            }

// Gắn sự kiện cho các nút "Previous" và "Next"
                                                            document.getElementById('prevPage').addEventListener('click', prevPage);
                                                            document.getElementById('nextPage').addEventListener('click', nextPage);

// Hiển thị trang đầu tiên khi trang tải
                                                            displayTablePage(currentPage);
    </script>
</body>
</html>