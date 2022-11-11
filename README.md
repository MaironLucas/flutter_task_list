# flutter_task_list

Um projeto da disciplina de Programação de dispositivos móveis!

## Instruções para executar

Executar `git clone https://github.com/MaironLucas/flutter_task_list`;

Executar `git checkout master`;

Executar `git pull`;

Executar `flutter pub get`;

Abrir um emulador de android, preferencialmente com a API 30 e na dimensão **1080x1920**;

Executar `flutter run`;

## Qual o objetivo do app?

O App será uma ferramenta para criação e compartilhamento de listas de tarefas (sejam essas atividades do dia a dia ou compras de mercado, por exemplo). Primeiramente, o usuário terá que realizar um cadastro utilizando email e nome. Tendo logado, ele será capaz de, na página inicial, criar novas listas e visualizar as listas já criadas. Quando uma lista é clicada, a página de detalhes dela irá abrir onde será possível tanto adicionar produtos a ela quanto compartilhar essa lista com outro usuário. O compartilhamento será feito através da geração de um QR Code que será lido pela pessoa com a qual a lista será compartilhada. Dessa forma, ambos os usuários poderão editar uma mesma lista.

## O que foi implementado nesse envio?

Nesse envio, implementamos as telas que faltaram no primeiro envio: a home com a lista de tarefas, os detalhes de uma tarefa específica e a tela de configurações. Implementamos o login utilizando o FirebaseAuth e, para o armazenamento de tarefas e passos para cumpri-la, utilizados o Realtime Database. Como funcionalidades faltantes, para a próxima entrega pretendemos transformar a tela de configurações em um modal que vem da direita para a esquerda e também uma tela onde terá as informações do usuário, assim como a opção de definir uma fotografia (aqui implementaremos o uso de API). Além disso, vamos melhorar a tela de listagem de tarefas e de passos no quesito visual. Também iremos trazer a funcionalidade de deixar o botão indisponivel quando um campo obrigatório não é preenchido em todos os dialogs do app, pois não houve tempo de fazer para essa entrega.
Quanto a bugs, a ordenação dos itens não está funcionando completamente, a seleção do usuário se perde em caso de rebuild, por isso na próxima entrega guardaremos essa escolha num bando de dados local (Hive). O dialog de edição dos dados do usuário não está fechando, não consegui descobrir a razão disso ainda.

## Como as atividades foram divididas?
Alan e Tiago trabalharam na parte visual, criando os conceitos das telas e desenvolvendo isso no Flutter;
Mairon fez a integração do App com o Firebase, assim como a gestão dos estados do app;