# GeoSafe 🛡️

## 📍 O que é o GeoSafe

O **GeoSafe** é uma plataforma comunitária de consciência situacional urbana. Nosso objetivo é democratizar o acesso a informações em tempo real sobre segurança e utilidade pública, permitindo que os próprios cidadãos relatem e validem eventos em suas cidades.

Acreditamos que a melhor fonte de informação sobre um bairro é quem vive e transita por ele. O GeoSafe transforma o mapa da cidade em um organismo vivo, onde a colaboração direta gera segurança para todos.

**"GeoSafe: Do povo, para o povo."**

---

## 🚀 Funcionalidades Principais

### 🔍 Lupa GeoSafe (Busca Integrada)
O "cérebro" do nosso mapa. Ao buscar um endereço, o app não apenas localiza o ponto, mas ativa camadas de inteligência:
- **Filtro de Proximidade:** Exibe automaticamente apenas alertas em um raio de **10km** do local buscado, limpando o ruído visual.
- **Clima de Segurança (Safety Score):** Calcula um score de risco em tempo real baseado nos alertas dos últimos **1km**.
- **Análise 24h:** O score prioriza eventos ocorridos nas últimas 24 horas para garantir que o "clima" reflita o momento atual.

### ⏳ Relevância Temporal
Para manter o mapa sempre atualizado e confiável, os alertas possuem um ciclo de vida:
- **Duração:** Cada alerta permanece visível no mapa por até **30 dias (720 horas)**.
- **Fading Visual:** Alertas novos são vibrantes. Conforme envelhecem, perdem opacidade (até o limite de 0.4) para indicar que a informação pode estar datada.

### 🏆 Sistema de Reputação (Geopontos)
A credibilidade é o nosso maior ativo. Usuários ganham pontos quando a comunidade valida suas informações:
- **Relevância:** Cada voto de "Relevante" recebido concede **+10 Geopontos** ao autor.
- **Níveis de Confiança:**
  - **🥉 Bronze:** Usuário recém-chegado (< 100 pts).
  - **🥈 Prata:** Membro ativo da comunidade (< 500 pts).
  - **🥇 Ouro:** Colaborador frequente e confiável (< 1000 pts).
  - **💎 Verificado:** Embaixador da segurança urbana (1000+ pts ou verificação manual).

---

## 🗺️ Próximos Passos (Roadmap)

1.  **Zonas de Interesse (Meus Lugares):** Permitir que o usuário salve locais críticos (Casa, Trabalho, Escola) para monitoramento rápido.
2.  **Notificações Preventivas:** Avisar o usuário caso um alerta de "Perigo" seja gerado em uma de suas Zonas de Interesse.
3.  **Categorização Semântica:** Refinar as categorias de alertas (Segurança, Trânsito, Utilidade Pública) para filtros mais precisos.
4.  **Expansão Nacional:** Otimização de performance para suporte a grandes volumes de dados em múltiplas capitais simultaneamente.

---

## 🛠️ Configuração do Ambiente

A aplicação é construída com **Ruby on Rails 7**, **Hotwire (Turbo/Stimulus)** e **PostgreSQL**.

### Pré-requisitos
- Ruby (ver arquivo `.ruby-version`)
- PostgreSQL 14+
- Google Maps API Key (com as bibliotecas `Maps` e `Places` ativadas)

### Inicialização
1.  **Instale as dependências:**
    ```bash
    bundle install
    npm install
    ```
2.  **Configure o Banco de Dados:**
    ```bash
    rails db:create
    rails db:migrate
    ```
3.  **Inicie o servidor de desenvolvimento:**
    ```bash
    bin/dev
    ```
    *A aplicação estará disponível em `http://localhost:3000`.*
