import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import react from '@astrojs/react';
import tailwind from '@astrojs/tailwind';

// https://astro.build/config
export default defineConfig({
	trailingSlash: 'always',
	integrations: [
		starlight({
			title: 'Flake FHS',
			defaultLocale: 'zh-cn',
			locales: {
				'zh-cn': {
					label: '简体中文',
					lang: 'zh-CN',
				},
				en: {
					label: 'English',
					lang: 'en',
				},
			},
			logo: {
				src: './src/assets/logo.svg',
			},
			social: {
				github: 'https://github.com/luochen1990/flake-fhs',
			},
			sidebar: [
				{
					label: '开始使用',
					items: [
						// Landing page is handled automatically, adding guides
						{ label: '快速上手', slug: 'manual' },
						{ label: '目录映射表', slug: 'directory-map' },
					],
				},
				{
					label: '核心指南',
					items: [
						{ label: '系统配置 (Hosts)', slug: 'manual-hosts' },
						{ label: 'NixOS 模块 (Modules)', slug: 'manual-modules' },
						{ label: '软件包 (Packages)', slug: 'manual-pkgs' },
						{ label: '包域 (Scope)', slug: 'manual-pkgs-scope' },
						{ label: '应用程序 (Apps)', slug: 'manual-apps' },
						{ label: '测试与检查 (Checks)', slug: 'manual-checks' },
						{ label: '开发环境 (Shells)', slug: 'manual-shells' },
						{ label: '函数库 (Lib)', slug: 'manual-lib' },
						{ label: '模板 (Templates)', slug: 'manual-templates' },
					],
				},
				{
					label: '配置参考',
					items: [
						{ label: '全局配置', slug: 'manual-config' },
						{ label: '最佳实践', slug: 'manual-best-practices' },
					],
				},
			],
			disable404Route: true,
			customCss: [
				'./src/styles/custom.css',
			],
		}),
		react(),
		tailwind({ applyBaseStyles: false }),
	],
});
