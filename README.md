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

### 📍 Zonas de Interesse (Meus Lugares)
Otimização do monitoramento pessoal através de locais salvos:
- **Gestão de Zonas:** Cadastro de até **3 locais estratégicos** (ex: Casa, Trabalho, Escola) com identificação personalizada.
- **Navegação Expressa:** Filtro inteligente na Home para alternar o foco do mapa instantaneamente entre as zonas salvas.
- **Interface Modal:** Fluxo de criação e edição totalmente via modais Turbo, sem recarregamento de página, garantindo agilidade.
- **Toasts de Feedback:** Sistema de notificações em tempo real (Toasts) para confirmação de ações de salvamento e exclusão.

### 🔔 Notificações em Tempo Real (Zonas de Interesse)
Segurança preventiva ativa para locais de alta importância para o usuário:
- **Detecção de Proximidade:** Quando um alerta de perigo (**DANGER**) é gerado em um raio de **5km** de qualquer Zona de Interesse cadastrada, o sistema dispara uma notificação automática.
- **Transmissão Instantânea (ActionCable/Turbo Stream):** A notificação é entregue sem necessidade de recarregar a tela:
  - **Sininho Inteligente:** Atualização do badge do sininho de notificações e de sua lista na barra de navegação.
  - **Toast Deslizante (Push-Style):** Exibição temporária de um alerta vermelho flutuante que desaparece após 5 segundos.
- **Integração Dinâmica com o Mapa:** Ao clicar no aviso flutuante ou no item do sininho, a aplicação impede recarregamentos de página (se o usuário já estiver na home), centraliza o mapa no alerta de destino e abre a modal de detalhes de segurança na hora.
- **Privacidade do Usuário:** Para dar tranquilidade e segurança aos membros da comunidade, os dados do criador (como username/nome) são ocultados nos detalhes dos alertas, restando visível apenas o seu **nível de confiança (Bronze, Prata, Ouro, Verificado)**.

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

1.  **✅ Zonas de Interesse:** Implementado sistema de gestão de locais salvos com navegação rápida.
2.  **✅ Notificações Preventivas em Tempo Real:** Concluído aviso instantâneo via ActionCable (bell/toasts) para alertas de perigo em raios de 5km das Zonas de Interesse do usuário, com foco e pan no mapa dinâmicos sem reloads.
3.  **Categorização Semântica:** Refinar as categorias de alertas (Segurança, Trânsito, Utilidade Pública) para filtros mais precisos.
4.  **Integração de Notificações Push:** Enviar alertas diretamente para o dispositivo do usuário (PWA ou Mobile) mesmo com o navegador fechado.
5.  **Expansão Nacional:** Otimização de performance para suporte a grandes volumes de dados em múltiplas cidades.

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
