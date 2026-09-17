-- --------------------------------------------------------
-- 主机:                           127.0.0.1
-- 服务器版本:                        8.0.12 - MySQL Community Server - GPL
-- 服务器操作系统:                      Win64
-- HeidiSQL 版本:                  9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- 导出 fineui_core_appbox 的数据库结构
CREATE DATABASE IF NOT EXISTS `fineui_core_appbox` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */;
USE `fineui_core_appbox`;

-- 导出  表 fineui_core_appbox.configs 结构
CREATE TABLE IF NOT EXISTS `configs` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ConfigKey` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `ConfigValue` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `Remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 正在导出表  fineui_core_appbox.configs 的数据：~4 rows (大约)
DELETE FROM `configs`;
/*!40000 ALTER TABLE `configs` DISABLE KEYS */;
INSERT INTO `configs` (`ID`, `ConfigKey`, `ConfigValue`, `Remark`) VALUES
	(1, 'Title', 'FineUI.Core.AppBox.Dapper', '网站的标题'),
	(2, 'PageSize', '20', '表格每页显示的个数'),
	(3, 'Theme', 'pure_purple', '网站主题'),
	(4, 'HelpList', '[{\r\n    "Text": "万年历",\r\n    "Icon": "Calendar",\r\n    "ID": "wannianli",\r\n    "URL": "~/Admin/HelpWanNianLi"\r\n},\r\n{\r\n    "Text": "科学计算器",\r\n    "Icon": "Calculator",\r\n    "ID": "jisuanqi",\r\n    "URL": "~/Admin/HelpJiSuanQi"\r\n},\r\n{\r\n    "Text": "系统帮助",\r\n    "Icon": "Help",\r\n    "ID": "help",\r\n    "URL": "~/Admin/Help"\r\n}]', '帮助下拉列表的JSON字符串');
/*!40000 ALTER TABLE `configs` ENABLE KEYS */;

-- 导出  表 fineui_core_appbox.depts 结构
CREATE TABLE IF NOT EXISTS `depts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `SortIndex` int(11) NOT NULL,
  `Remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `ParentID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `ParentID` (`ParentID`),
  CONSTRAINT `Dept_Parent` FOREIGN KEY (`ParentID`) REFERENCES `depts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 正在导出表  fineui_core_appbox.depts 的数据：~18 rows (大约)
DELETE FROM `depts`;
/*!40000 ALTER TABLE `depts` DISABLE KEYS */;
INSERT INTO `depts` (`ID`, `Name`, `SortIndex`, `Remark`, `ParentID`) VALUES
	(1, '研发部', 1, '顶级部门', NULL),
	(2, '销售部', 2, '顶级部门', NULL),
	(3, '客服部', 3, '顶级部门', NULL),
	(4, '行政部', 5, '顶级部门', NULL),
	(5, '运输部', 3, '二级部门', 4),
	(6, '开发部', 1, '二级部门', 1),
	(7, '测试部', 2, '二级部门', 1),
	(8, '直销部', 1, '二级部门', 2),
	(9, '渠道部', 2, '二级部门', 2),
	(10, '实施部', 1, '二级部门', 3),
	(11, '售后服务部', 2, '二级部门', 3),
	(12, '大客户服务部', 3, '二级部门', 3),
	(13, '财务部', 4, '顶级部门', NULL),
	(14, '人事部', 1, '二级部门', 4),
	(15, '后勤部', 2, '二级部门', 4),
	(16, '省内运输部', 1, '三级部门', 5),
	(17, '国内运输部', 2, '三级部门', 5),
	(18, '国际运输部', 3, '三级部门', 5);
/*!40000 ALTER TABLE `depts` ENABLE KEYS */;

-- 导出  表 fineui_core_appbox.logs 结构
CREATE TABLE IF NOT EXISTS `logs` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Level` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Logger` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Message` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Exception` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `LogTime` datetime NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 正在导出表  fineui_core_appbox.logs 的数据：~0 rows (大约)
DELETE FROM `logs`;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;

-- 导出  表 fineui_core_appbox.menus 结构
CREATE TABLE IF NOT EXISTS `menus` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `ImageUrl` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `NavigateUrl` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `SortIndex` int(11) NOT NULL,
  `ParentID` int(11) DEFAULT NULL,
  `ViewPowerID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `ParentID` (`ParentID`),
  KEY `ViewPowerID` (`ViewPowerID`),
  CONSTRAINT `Menu_Parent` FOREIGN KEY (`ParentID`) REFERENCES `menus` (`id`),
  CONSTRAINT `Menu_ViewPower` FOREIGN KEY (`ViewPowerID`) REFERENCES `powers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 正在导出表  fineui_core_appbox.menus 的数据：~19 rows (大约)
DELETE FROM `menus`;
/*!40000 ALTER TABLE `menus` DISABLE KEYS */;
INSERT INTO `menus` (`ID`, `Name`, `ImageUrl`, `NavigateUrl`, `Remark`, `SortIndex`, `ParentID`, `ViewPowerID`) VALUES
	(1, '系统管理', '~/res/icon/tag_yellow.png', '', '顶级菜单', 1, NULL, NULL),
	(2, '测试菜单', '~/res/icon/folder.png', NULL, '顶级菜单', 1, NULL, NULL),
	(3, '测试目录1', '~/res/icon/folder.png', NULL, '二级菜单', 10, 2, NULL),
	(4, '用户管理', '~/res/icon/tag_blue.png', '~/Admin/UserList', '二级菜单', 10, 1, 1),
	(5, '职称管理', '~/res/icon/tag_blue.png', '~/Admin/Title', '二级菜单', 20, 1, 22),
	(6, '职称用户管理', '~/res/icon/tag_blue.png', '~/Admin/TitleUser', '二级菜单', 30, 1, 26),
	(7, '部门管理', '~/res/icon/tag_blue.png', '~/Admin/Dept', '二级菜单', 40, 1, 29),
	(8, '部门用户管理', '~/res/icon/tag_blue.png', '~/Admin/DeptUser', '二级菜单', 50, 1, 33),
	(9, '角色管理', '~/res/icon/tag_blue.png', '~/Admin/Role', '二级菜单', 60, 1, 6),
	(10, '角色用户管理', '~/res/icon/tag_blue.png', '~/Admin/RoleUser', '二级菜单', 70, 1, 10),
	(11, '权限管理', '~/res/icon/tag_blue.png', '~/Admin/Power', '二级菜单', 80, 1, 36),
	(12, '角色权限管理', '~/res/icon/tag_blue.png', '~/Admin/RolePower', '二级菜单', 90, 1, 40),
	(13, '菜单管理', '~/res/icon/tag_blue.png', '~/Admin/Menu', '二级菜单', 100, 1, 16),
	(14, '在线统计', '~/res/icon/tag_blue.png', '~/Admin/Online', '二级菜单', 110, 1, 13),
	(15, '系统配置', '~/res/icon/tag_blue.png', '~/Admin/Config', '二级菜单', 120, 1, 14),
	(16, '修改密码', '~/res/icon/tag_blue.png', '~/Admin/ChangePassword', '二级菜单', 130, 1, NULL),
	(17, '测试页面1', '~/res/icon/page.png', '~/Test/Test1', '三级菜单', 10, 3, 42),
	(18, '测试页面2', '~/res/icon/page.png', '~/Test/Test2', '二级菜单', 10, 2, 43);
/*!40000 ALTER TABLE `menus` ENABLE KEYS */;

-- 导出  表 fineui_core_appbox.onlines 结构
CREATE TABLE IF NOT EXISTS `onlines` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IPAdddress` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `LoginTime` datetime NOT NULL,
  `UpdateTime` datetime DEFAULT NULL,
  `UserID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `Online_User` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 正在导出表  fineui_core_appbox.onlines 的数据：~0 rows (大约)
DELETE FROM `onlines`;
/*!40000 ALTER TABLE `onlines` DISABLE KEYS */;
INSERT INTO `onlines` (`ID`, `IPAdddress`, `LoginTime`, `UpdateTime`, `UserID`) VALUES
	(1, '::1', '2018-08-19 10:58:11', '2018-08-19 11:23:28', 206);
/*!40000 ALTER TABLE `onlines` ENABLE KEYS */;

-- 导出  表 fineui_core_appbox.powers 结构
CREATE TABLE IF NOT EXISTS `powers` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `GroupName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `Title` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `Remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 正在导出表  fineui_core_appbox.powers 的数据：~43 rows (大约)
DELETE FROM `powers`;
/*!40000 ALTER TABLE `powers` DISABLE KEYS */;
INSERT INTO `powers` (`ID`, `Name`, `GroupName`, `Title`, `Remark`) VALUES
	(1, 'CoreUserView', 'CoreUser', '浏览用户列表', NULL),
	(2, 'CoreUserNew', 'CoreUser', '新增用户', NULL),
	(3, 'CoreUserEdit', 'CoreUser', '编辑用户', NULL),
	(4, 'CoreUserDelete', 'CoreUser', '删除用户', NULL),
	(5, 'CoreUserChangePassword', 'CoreUser', '修改用户登陆密码', NULL),
	(6, 'CoreRoleView', 'CoreRole', '浏览角色列表', NULL),
	(7, 'CoreRoleNew', 'CoreRole', '新增角色', NULL),
	(8, 'CoreRoleEdit', 'CoreRole', '编辑角色', NULL),
	(9, 'CoreRoleDelete', 'CoreRole', '删除角色', NULL),
	(10, 'CoreRoleUserView', 'CoreRoleUser', '浏览角色用户列表', NULL),
	(11, 'CoreRoleUserNew', 'CoreRoleUser', '向角色添加用户', NULL),
	(12, 'CoreRoleUserDelete', 'CoreRoleUser', '从角色中删除用户', NULL),
	(13, 'CoreOnlineView', 'CoreOnline', '浏览在线用户列表', NULL),
	(14, 'CoreConfigView', 'CoreConfig', '浏览全局配置参数', NULL),
	(15, 'CoreConfigEdit', 'CoreConfig', '修改全局配置参数', NULL),
	(16, 'CoreMenuView', 'CoreMenu', '浏览菜单列表', NULL),
	(17, 'CoreMenuNew', 'CoreMenu', '新增菜单', NULL),
	(18, 'CoreMenuEdit', 'CoreMenu', '编辑菜单', NULL),
	(19, 'CoreMenuDelete', 'CoreMenu', '删除菜单', NULL),
	(20, 'CoreLogView', 'CoreLog', '浏览日志列表', NULL),
	(21, 'CoreLogDelete', 'CoreLog', '删除日志', NULL),
	(22, 'CoreTitleView', 'CoreTitle', '浏览职务列表', NULL),
	(23, 'CoreTitleNew', 'CoreTitle', '新增职务', NULL),
	(24, 'CoreTitleEdit', 'CoreTitle', '编辑职务', NULL),
	(25, 'CoreTitleDelete', 'CoreTitle', '删除职务', NULL),
	(26, 'CoreTitleUserView', 'CoreTitleUser', '浏览职务用户列表', NULL),
	(27, 'CoreTitleUserNew', 'CoreTitleUser', '向职务添加用户', NULL),
	(28, 'CoreTitleUserDelete', 'CoreTitleUser', '从职务中删除用户', NULL),
	(29, 'CoreDeptView', 'CoreDept', '浏览部门列表', NULL),
	(30, 'CoreDeptNew', 'CoreDept', '新增部门', NULL),
	(31, 'CoreDeptEdit', 'CoreDept', '编辑部门', NULL),
	(32, 'CoreDeptDelete', 'CoreDept', '删除部门', NULL),
	(33, 'CoreDeptUserView', 'CoreDeptUser', '浏览部门用户列表', NULL),
	(34, 'CoreDeptUserNew', 'CoreDeptUser', '向部门添加用户', NULL),
	(35, 'CoreDeptUserDelete', 'CoreDeptUser', '从部门中删除用户', NULL),
	(36, 'CorePowerView', 'CorePower', '浏览权限列表', NULL),
	(37, 'CorePowerNew', 'CorePower', '新增权限', NULL),
	(38, 'CorePowerEdit', 'CorePower', '编辑权限', NULL),
	(39, 'CorePowerDelete', 'CorePower', '删除权限', NULL),
	(40, 'CoreRolePowerView', 'CoreRolePower', '浏览角色权限列表', NULL),
	(41, 'CoreRolePowerEdit', 'CoreRolePower', '编辑角色权限', NULL),
	(42, 'TestPage1View', 'Test', '浏览测试页面一', NULL),
	(43, 'TestPage2View', 'Test', '浏览测试页面二', NULL);
/*!40000 ALTER TABLE `powers` ENABLE KEYS */;

-- 导出  表 fineui_core_appbox.rolepowers 结构
CREATE TABLE IF NOT EXISTS `rolepowers` (
  `RoleID` int(11) NOT NULL,
  `PowerID` int(11) NOT NULL,
  PRIMARY KEY (`RoleID`,`PowerID`),
  KEY `Role_Powers_Target` (`PowerID`),
  CONSTRAINT `Role_Powers_Source` FOREIGN KEY (`RoleID`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Role_Powers_Target` FOREIGN KEY (`PowerID`) REFERENCES `powers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 正在导出表  fineui_core_appbox.rolepowers 的数据：~4 rows (大约)
DELETE FROM `rolepowers`;
/*!40000 ALTER TABLE `rolepowers` DISABLE KEYS */;
INSERT INTO `rolepowers` (`RoleID`, `PowerID`) VALUES
	(1, 1),
	(1, 29),
	(3, 29),
	(1, 31),
	(3, 34);
/*!40000 ALTER TABLE `rolepowers` ENABLE KEYS */;

-- 导出  表 fineui_core_appbox.roles 结构
CREATE TABLE IF NOT EXISTS `roles` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `Remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 正在导出表  fineui_core_appbox.roles 的数据：~7 rows (大约)
DELETE FROM `roles`;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` (`ID`, `Name`, `Remark`) VALUES
	(1, '系统管理员', ''),
	(2, '部门管理员', ''),
	(3, '项目经理', ''),
	(4, '开发经理', ''),
	(5, '开发人员', ''),
	(6, '后勤人员', ''),
	(7, '外包人员', '');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;

-- 导出  表 fineui_core_appbox.roleusers 结构
CREATE TABLE IF NOT EXISTS `roleusers` (
  `RoleID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  PRIMARY KEY (`RoleID`,`UserID`),
  KEY `Role_Users_Target` (`UserID`),
  CONSTRAINT `Role_Users_Source` FOREIGN KEY (`RoleID`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Role_Users_Target` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 正在导出表  fineui_core_appbox.roleusers 的数据：~4 rows (大约)
DELETE FROM `roleusers`;
/*!40000 ALTER TABLE `roleusers` DISABLE KEYS */;
INSERT INTO `roleusers` (`RoleID`, `UserID`) VALUES
	(1, 206),
	(3, 206),
	(4, 206),
	(6, 206);
/*!40000 ALTER TABLE `roleusers` ENABLE KEYS */;

-- 导出  表 fineui_core_appbox.titles 结构
CREATE TABLE IF NOT EXISTS `titles` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `Remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 正在导出表  fineui_core_appbox.titles 的数据：~4 rows (大约)
DELETE FROM `titles`;
/*!40000 ALTER TABLE `titles` DISABLE KEYS */;
INSERT INTO `titles` (`ID`, `Name`, `Remark`) VALUES
	(1, '总经理', NULL),
	(2, '部门经理', NULL),
	(3, '高级工程师', NULL),
	(4, '工程师', NULL);
/*!40000 ALTER TABLE `titles` ENABLE KEYS */;

-- 导出  表 fineui_core_appbox.titleusers 结构
CREATE TABLE IF NOT EXISTS `titleusers` (
  `TitleID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  PRIMARY KEY (`TitleID`,`UserID`),
  KEY `Title_Users_Target` (`UserID`),
  CONSTRAINT `Title_Users_Source` FOREIGN KEY (`TitleID`) REFERENCES `titles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Title_Users_Target` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 正在导出表  fineui_core_appbox.titleusers 的数据：~0 rows (大约)
DELETE FROM `titleusers`;
/*!40000 ALTER TABLE `titleusers` DISABLE KEYS */;
/*!40000 ALTER TABLE `titleusers` ENABLE KEYS */;

-- 导出  表 fineui_core_appbox.users 结构
CREATE TABLE IF NOT EXISTS `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `Email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `Password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `Enabled` tinyint(1) NOT NULL,
  `Gender` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `ChineseName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `EnglishName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Photo` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `QQ` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `CompanyEmail` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `OfficePhone` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `OfficePhoneExt` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `HomePhone` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `CellPhone` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Address` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `IdentityCard` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Birthday` datetime DEFAULT NULL,
  `TakeOfficeTime` datetime DEFAULT NULL,
  `LastLoginTime` datetime DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `DeptID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `DeptID` (`DeptID`),
  CONSTRAINT `Dept_Users` FOREIGN KEY (`DeptID`) REFERENCES `depts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 正在导出表  fineui_core_appbox.users 的数据：~206 rows (大约)
DELETE FROM `users`;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`ID`, `Name`, `Email`, `Password`, `Enabled`, `Gender`, `ChineseName`, `EnglishName`, `Photo`, `QQ`, `CompanyEmail`, `OfficePhone`, `OfficePhoneExt`, `HomePhone`, `CellPhone`, `Address`, `Remark`, `IdentityCard`, `Birthday`, `TakeOfficeTime`, `LastLoginTime`, `CreateTime`, `DeptID`) VALUES
	(1, 'user0', 'user0@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '童光喜', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(2, 'user2', 'user2@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '方原柏', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(3, 'user4', 'user4@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '祝春亚', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(4, 'user6', 'user6@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '涂辉', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(5, 'user8', 'user8@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '舒兆国', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(6, 'user10', 'user10@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '熊忠文', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(7, 'user12', 'user12@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '徐吉琳', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(8, 'user14', 'user14@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '方金海', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(9, 'user16', 'user16@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '包卫峰', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(10, 'user18', 'user18@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '靖小燕', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(11, 'user20', 'user20@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '杨习斌', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(12, 'user22', 'user22@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '徐长旺', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(13, 'user24', 'user24@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '聂建雄', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(14, 'user26', 'user26@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '周敦友', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(15, 'user28', 'user28@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '陈友庭', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(16, 'user30', 'user30@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '陆静芳', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(17, 'user32', 'user32@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '袁国柱', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(18, 'user34', 'user34@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '骆新桂', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(19, 'user36', 'user36@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '许治国', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(20, 'user38', 'user38@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '马先加', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(21, 'user40', 'user40@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '赵恢川', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(22, 'user42', 'user42@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '柯常胜', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(23, 'user44', 'user44@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '黄国鹏', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(24, 'user46', 'user46@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '柯尊北', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(25, 'user48', 'user48@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '刘海云', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(26, 'user50', 'user50@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '罗清波', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(27, 'user52', 'user52@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '张业权', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(28, 'user54', 'user54@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '丁溯鋆', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(29, 'user56', 'user56@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '吴俊', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(30, 'user58', 'user58@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '郑江', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(31, 'user60', 'user60@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '李亚华', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(32, 'user62', 'user62@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '石光富', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(33, 'user64', 'user64@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '谭志洪', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(34, 'user66', 'user66@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '胡中生', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(35, 'user68', 'user68@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '董龙剑', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(36, 'user70', 'user70@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '陈红', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(37, 'user72', 'user72@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '汪海平', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(38, 'user74', 'user74@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '彭道洲', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(39, 'user76', 'user76@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '尹莉君', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(40, 'user78', 'user78@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '占耀玲', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(41, 'user80', 'user80@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '付杰', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(42, 'user82', 'user82@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '王红艳', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(43, 'user84', 'user84@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '邝兴', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(44, 'user86', 'user86@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '饶玮', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(45, 'user88', 'user88@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '王方胜', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(46, 'user90', 'user90@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '陈劲松', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(47, 'user92', 'user92@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '邓庆华', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(48, 'user94', 'user94@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '王石林', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(49, 'user96', 'user96@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '胡俊明', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(50, 'user98', 'user98@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '索相龙', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', 1),
	(51, 'user100', 'user100@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '陈海军', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(52, 'user102', 'user102@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '吴文涛', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(53, 'user104', 'user104@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '熊望梅', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(54, 'user106', 'user106@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '段丽华', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(55, 'user108', 'user108@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '胡莎莎', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(56, 'user110', 'user110@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '徐友安', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(57, 'user112', 'user112@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '肖诗涛', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(58, 'user114', 'user114@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '王闯', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(59, 'user116', 'user116@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '余兴龙', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(60, 'user118', 'user118@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '芦荫杰', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(61, 'user120', 'user120@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '丁金富', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(62, 'user122', 'user122@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '谭军令', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(63, 'user124', 'user124@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '鄢旭燕', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(64, 'user126', 'user126@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '田坤', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(65, 'user128', 'user128@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '夏德胜', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(66, 'user130', 'user130@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '喻显发', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(67, 'user132', 'user132@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '马兴宝', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(68, 'user134', 'user134@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '孙学涛', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(69, 'user136', 'user136@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '陶云成', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(70, 'user138', 'user138@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '马远健', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(71, 'user140', 'user140@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '田华', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(72, 'user142', 'user142@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '聂子森', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(73, 'user144', 'user144@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '郑永军', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(74, 'user146', 'user146@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '余昌平', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(75, 'user148', 'user148@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '陶俊华', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(76, 'user150', 'user150@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '李小林', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(77, 'user152', 'user152@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '李荣宝', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(78, 'user154', 'user154@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '梅盈凯', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(79, 'user156', 'user156@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '张元群', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(80, 'user158', 'user158@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '郝新华', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(81, 'user160', 'user160@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '刘红涛', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(82, 'user162', 'user162@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '向志强', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(83, 'user164', 'user164@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '伍小峰', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(84, 'user166', 'user166@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '胡勇民', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(85, 'user168', 'user168@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '黄定祥', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(86, 'user170', 'user170@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '高红香', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(87, 'user172', 'user172@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '刘军', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(88, 'user174', 'user174@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '叶松', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(89, 'user176', 'user176@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '易俊林', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(90, 'user178', 'user178@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '张威', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(91, 'user180', 'user180@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '刘卫华', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(92, 'user182', 'user182@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '李浩', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(93, 'user184', 'user184@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '李寿庚', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(94, 'user186', 'user186@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '涂洋', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(95, 'user188', 'user188@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '曹晶', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(96, 'user190', 'user190@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '陈辉', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(97, 'user192', 'user192@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '彭博', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(98, 'user194', 'user194@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '严雪冰', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(99, 'user196', 'user196@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '刘青', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(100, 'user198', 'user198@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '印媛', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(101, 'user200', 'user200@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '吴道雄', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(102, 'user202', 'user202@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '邓旻', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(103, 'user204', 'user204@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '陈骏', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(104, 'user206', 'user206@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '崔波', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(105, 'user208', 'user208@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '韩静颐', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(106, 'user210', 'user210@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '严安勇', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(107, 'user212', 'user212@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '刘攀', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(108, 'user214', 'user214@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '刘艳', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(109, 'user216', 'user216@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '孙昕', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(110, 'user218', 'user218@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '郑新', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(111, 'user220', 'user220@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '徐睿', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(112, 'user222', 'user222@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '李月杰', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(113, 'user224', 'user224@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '吕焱鑫', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(114, 'user226', 'user226@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '刘沈', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(115, 'user228', 'user228@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '朱绍军', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(116, 'user230', 'user230@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '马茜', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(117, 'user232', 'user232@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '唐蕾', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(118, 'user234', 'user234@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '刘姣', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(119, 'user236', 'user236@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '于芳', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(120, 'user238', 'user238@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '吴健', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(121, 'user240', 'user240@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '张丹梅', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(122, 'user242', 'user242@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '王燕', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(123, 'user244', 'user244@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '贾兆梅', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(124, 'user246', 'user246@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '程柏漠', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(125, 'user248', 'user248@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '程辉', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(126, 'user250', 'user250@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '任明慧', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(127, 'user252', 'user252@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '焦莹', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(128, 'user254', 'user254@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '马淑娟', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(129, 'user256', 'user256@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '徐涛', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(130, 'user258', 'user258@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '孙庆国', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(131, 'user260', 'user260@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '刘胜', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(132, 'user262', 'user262@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '傅广凤', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(133, 'user264', 'user264@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '袁弘', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(134, 'user266', 'user266@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '高令旭', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(135, 'user268', 'user268@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '栾树权', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(136, 'user270', 'user270@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '申霞', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(137, 'user272', 'user272@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '韩文萍', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(138, 'user274', 'user274@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '隋艳', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(139, 'user276', 'user276@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '邢海洲', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(140, 'user278', 'user278@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '王宁', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(141, 'user280', 'user280@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '陈晶', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(142, 'user282', 'user282@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '吕翠', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(143, 'user284', 'user284@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '刘少敏', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(144, 'user286', 'user286@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '刘少君', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(145, 'user288', 'user288@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '孔鹏', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(146, 'user290', 'user290@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '张冰', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(147, 'user292', 'user292@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '王芳', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(148, 'user294', 'user294@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '万世忠', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(149, 'user296', 'user296@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '徐凡', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(150, 'user298', 'user298@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '张玉梅', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(151, 'user300', 'user300@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '何莉', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(152, 'user302', 'user302@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '时会云', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(153, 'user304', 'user304@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '王玉杰', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(154, 'user306', 'user306@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '谭素英', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(155, 'user308', 'user308@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '李艳红', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(156, 'user310', 'user310@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '刘素莉', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(157, 'user312', 'user312@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '王旭海', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(158, 'user314', 'user314@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '安丽梅', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(159, 'user316', 'user316@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '姚露', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(160, 'user318', 'user318@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '贾颖', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(161, 'user320', 'user320@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '曹微', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(162, 'user322', 'user322@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '黄经华', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(163, 'user324', 'user324@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '陈玉华', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(164, 'user326', 'user326@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '姜媛', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(165, 'user328', 'user328@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '魏立平', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(166, 'user330', 'user330@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '张萍', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(167, 'user332', 'user332@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '来辉', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(168, 'user334', 'user334@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '陈秀玫', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(169, 'user336', 'user336@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '石岩', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(170, 'user338', 'user338@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '王洪捍', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(171, 'user340', 'user340@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '张树军', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(172, 'user342', 'user342@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '李亚琴', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(173, 'user344', 'user344@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '王凤', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(174, 'user346', 'user346@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '王珊华', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(175, 'user348', 'user348@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '杨丹丹', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(176, 'user350', 'user350@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '教黎明', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(177, 'user352', 'user352@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '修晶', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(178, 'user354', 'user354@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '丁晓霞', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(179, 'user356', 'user356@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '张丽', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(180, 'user358', 'user358@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '郭素兰', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(181, 'user360', 'user360@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '徐艳丽', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(182, 'user362', 'user362@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '任子英', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(183, 'user364', 'user364@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '胡雁', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(184, 'user366', 'user366@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '彭洪亮', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(185, 'user368', 'user368@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '高玉珍', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(186, 'user370', 'user370@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '王玉姝', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(187, 'user372', 'user372@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '郑伟', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(188, 'user374', 'user374@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '姜春玲', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(189, 'user376', 'user376@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '张伟', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(190, 'user378', 'user378@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '王颖', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(191, 'user380', 'user380@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '金萍', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(192, 'user382', 'user382@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '孙望', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(193, 'user384', 'user384@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '闫宝东', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(194, 'user386', 'user386@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '周相永', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(195, 'user388', 'user388@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '杨美娜', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(196, 'user390', 'user390@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '欧立新', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(197, 'user392', 'user392@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '刘宝霞', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(198, 'user394', 'user394@163.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '刘艳杰', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(199, 'user396', 'user396@qq.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '宋艳平', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(200, 'user398', 'user398@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '李克', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(201, 'user400', 'user400@126.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '梁翠', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(202, 'user402', 'user402@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '宗宏伟', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(203, 'user404', 'user404@foxmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '刘国伟', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(204, 'user406', 'user406@gmail.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '敖志敏', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(205, 'user408', 'user408@outlook.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '女', '尹玲', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL),
	(206, 'admin', 'admin@examples.com', 'BGF85rT9S6rfd6JWAxwIdXVpBuO3svY0', 1, '男', '超级管理员', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-08-09 16:50:30', NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
