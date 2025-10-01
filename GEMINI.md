## Sobre o projeto
- Esse projeto se chama Geosafe e consiste em uma aplicação web com o objetivo de fornecer avisos sobre o que acontece nas localidades em que os usuários estão.

A aplicação utiliza a seguinte stack:
- Linguagem de programação Ruby com a utilização do framework Rails (Ruby On Rails) para desenvolvimento web
- authentication-zero do Lázaro Nixon (https://github.com/lazaronixon/authentication-zero) um generator para gerar a autenticação e sessão do usuário
- Tailwind CSS para a estilização no front-end
- Estou usando o Turbo para conseguir renderizar conteúdos em uma Single Page Application na aplicação
- O banco de dados escolhido para a aplicação é um banco de dados PostgreSQL que roda em um container no Docker, na porta padrão
- Para testes, estou trocando o minitest padrão do framework para usar o Rspec

Por enquanto é isso, logo mais pretendo realizar a integração com a API de mapas do Google para que seja possível adicionar a geolocalização para os usuários.

Estou buscando utilizar as melhores práticas da programação como Clean Code e tentando distribuir os domains arquiteturalmente no padrão do Ruby On Rails.