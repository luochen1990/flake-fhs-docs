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
						{ slug: 'why-flake-fhs' },
						{ slug: 'manual' },
						{ slug: 'more-examples' },
						{ slug: 'directory-map' },
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
						{ slug: 'manual-pkgs-scope' },
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
						{ slug: 'features-colmena' },
						{ slug: 'features-unified-build' },
						{ slug: 'features-gradual-adoption' },
						{ slug: 'features-treefmt' },
					],
				},
				{
					label: '配置参考',
					translations: {
						en: 'Configuration Reference',
					},
					items: [
						{ slug: 'manual-config' },
						{ slug: 'manual-best-practices' },
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
