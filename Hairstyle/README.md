# 💇‍♀️ Hairstyle 发型推荐 App

> “人会换发型，也会换心情，而这个 App，只为记录那些想尝试的瞬间。”

## ✨ 项目简介

Hairstyle 是一款专为 iOS 平台设计的发型推荐与试戴 App，主打灵感探索与图像交互。用户可以轻松浏览最新发型、上传照片进行比对、查看细节甚至裁剪图像。它既是工具，也是一面风格镜子。

## 📱 主要功能

- 首页横幅轮播（Banner）
- 分类推荐发型列表（最新款 / 染发款）
- 发型详情查看，支持颜色还原
- 自定义图片导入 / 拍照上传
- 图片裁剪与对比功能

## 🧱 项目结构

| 模块名 | 说明 |
|--------|------|
| `BannerCell.swift` | 首页顶部轮播图，自动滚动与点击响应 |
| `RecommendationCell.swift` | 横向发型列表，根据类型展示不同内容 |
| `ActionButtonsCell.swift` | 包含“导入照片”和“拍照上传”的按钮 |
| `HairDetailViewController.swift` | 发型详细页面，支持色彩还原与发型说明 |
| `CompareViewController.swift` | 对比两款发型的视觉展示 |
| `ImageCropViewController.swift` | 裁剪图片工具页面，辅助上传发型图像 |

## 🧑‍💻 技术栈

- **语言**：Swift 5
- **框架**：UIKit（纯手写 UI，未使用 Storyboard）
- **事件传递**：使用闭包实现 Cell ↔ Controller 的数据通信
- **布局方式**：Auto Layout + 部分手动 frame 控制

## 🚀 如何运行

1. 克隆项目：

```bash
git clone https://github.com/your-username/hairstyle-app.git