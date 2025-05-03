# FIJI 生物图像分析脚本集

用于生物医学图像分析的FIJI宏脚本集合。

语言: 中文 | [English](./README.md)

> ⚠️ **项目状态：早期开发阶段**
>
> 本项目目前处于早期开发阶段，尚未准备好用于生产环境。脚本正在积极开发和测试中。欢迎关注，但请注意目前功能还不稳定且不完整。
>
> 敬请期待后续更新！

## 简介

这个项目包含了一系列用于生物医学研究中常见图像分析任务的FIJI宏脚本。这些脚本旨在简化和标准化实验图像的分析流程，提高工作效率。

## 脚本分类

### Western Blot 分析
- 条带灰度值分析
- 多泳道分析

### 免疫组化分析
- DAB染色定量
- HE染色分析
- 组织面积测量

### 荧光图像分析
- 共定位分析
- 荧光强度分析
- 颗粒计数

### 划痕实验分析
- 划痕面积测量
- 细胞迁移轨迹分析

### 通用工具
- 批量处理
- 图像预处理
- 结果导出

## 安装说明

1. 下载脚本
   ```bash
   git clone https://github.com/vamond/fiji-bioimage-scripts.git
   ```

2. 复制所需脚本到FIJI宏目录
   - Windows: `%APPDATA%/Fiji.app/macros/`
   - MacOS: `/Applications/Fiji.app/macros/`
   - Linux: `~/Fiji.app/macros/`

3. 重启FIJI

## 使用教程

- 详细文字教程：[博客](https://www.vamond.cn)
- 视频教程：[B站](https://space.bilibili.com/your_channel_id)

## 注意事项

- 所有脚本都在FIJI (ImageJ 1.53c及以上版本) 测试通过
- 建议在使用前备份原始图像
- 部分脚本可能需要安装特定的FIJI插件

## 问题反馈

如有问题请通过以下方式反馈：

- GitHub Issues
- 博客：https://www.vamond.cn

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。 