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
					translations: {
						en: 'Getting Started',
					},
					items: [
						{ slug: 'tutorial-intro' },
						{ slug: 'tutorial-quick-start' },
						{ slug: 'tutorial-examples' },
						{ slug: 'tutorial-directory-map' },
					],
				},
				{
					label: '核心指南',
					translations: {
						en: 'Core Guides',
					},
					items: [
						{ slug: 'manual-hosts' },
						{ slug: 'manual-modules' },
						{ slug: 'manual-pkgs' },
						{ slug: 'manual-apps' },
						{ slug: 'manual-checks' },
						{ slug: 'manual-shells' },
						{ slug: 'manual-lib' },
						{ slug: 'manual-templates' },
					],
				},
				{
					label: '更多特性',
					translations: {
						en: 'More Features',
					},
					items: [
						{ slug: 'features-treefmt' },
						{ slug: 'features-unified-build' },
						{ slug: 'features-colmena' },
					],
				},
				{
					label: '进阶内容',
					translations: {
						en: 'Advanced Topics',
					},
					items: [
						{ slug: 'advanced-best-practices' },
						{ slug: 'advanced-pkgs-scope' },
						{ slug: 'advanced-config' },
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
