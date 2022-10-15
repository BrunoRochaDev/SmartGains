# SMART GAINS

Desafio Smart Fitness Coach - Sumário Executivo
(Projeto vencedor)

## Descrição do desafio

  O desafio que nos foi proposto foi elaborar um protótipo de funcionalidades para uma plataforma de Fitness Integrada, onde os principais objetivos são monitoração, avaliação e previsão do potencial atlético dos seus utilizadores.
  
  Decidimos desenvolver uma aplicação que, através de uma câmera, analisa a performance física do utilizador a fim de fornecer feedback durante a sua execução, estatísticas e previsão de desenvolvimento físico. Em outras palavras, é nossa expectativa que a nossa aplicação deveria oferecer uma experiência comparável à de um personal trainer com uma fração do custo e, portanto, efetivamente democratizando o acesso à fitness coaching.
  
## Estratégia

  Decidimos que a melhor maneira de monitorizar a perfomance física do utilizador seria através da avaliação da técnica da execução de exercícios de musculação, uma métrica amplamente utilizada no campo de fitness. Como muito dos exercícios selecionados necessitam do uso de barras de peso para atingir progressive overload, é imprescendível que a deteção do exercício funcione mesmo com parte do corpo obstruída (feature tipicamente ausente na maioria das aplicações deste tipo).
  
  Um personal trainer garante a segurança e o conforto do seu trainee. De modo a replicar essa interação, o nosso smart coach deverá enviar feedback imediato das repetições. Caso o utilizador esteja a fazer algo subótimo ou perigoso, o smart coach alerta-lo-á da correção a realizar. Estas correções estão em conformidade com recomendações profissionais e reputáveis. Outra funcionalidade será a deteção e a contagem das repetições em tempo real.
  
  Por último, queremos recolher dados, a partir dos quais, serão calculadas estatísticas usando técnicas de Data Analytics e Machine Learning, que servirão como avaliação do potencial atlético do utilizador previsão do seu  desenvolvimento físico ao longo do tempo;
  
  A aplicação também contará com uma interface de utilização de modo a permitir o uso das funcionalidades. Tendo em vista portabilidade e conveniência, esta deverá ser mobile (Android e iOS). 
  
  Para além disso, será necessário o uso de um sistema de base de dados para garantir persistência de dados (Data Persistency).
  
 ## Proposta de solução
 
 Para implementação das estratégias e objetivos previamente definidos, usamos Machine Vision, recorrendo à linguagem Python e os módulos OpenCV e MediaPipe. Estes permitiram realizar pose estimation do utilizador em tempo real, e assim, ter um modelo virtual de sua posição no espaço. Medidas foram tomadas para que os exercícios possam ser avaliados, mesmo com partes do corpo obstruídas por equipamento como barras e peso (investigámos também a possibilidade de fazer color tracking na barra de peso para recolha de dados adicionais).
 
 Para analisar a execução dos exercícios, usamos o ângulo e posição relativa das articulações para verificar se certas guias de execução, recomendadas por fisioteraupetuas e strength coaches, estão a ser seguidas. Desta forma, o utilizador recebe em tempo real a contagem de repetições do exercício que está a executar, bem como sugestões de como melhorar a sua forma.
 
 A arquitetura do projeto foi feita com base numa arquitetura de microserviços. Em outras palavras, é fácil expandir o repertório de exercícios - basta adicionar um novo conjunto de heurísticas a serem verificadas. A aplicação atualmente inclui heurísticas para trẽs exercícios: agachamento, bicep curl e flexões (um quarto exercício, o deadlift, está parcialmente implementado). Existem múltiplas dezenas de exercícios que poderiam ser facilmente implementados usando a nossa abordagem, acrescentando scalability.
 
 A partir das métricas dos utilizadores e dos dados recolhidos pela aplicação, calculamos o potencial físico do utilizador e fizemos uma análise preditiva do desenvolvimento físico ao longo do tempo do usuário.  A previsão é feita a partir do enquadramento de dados recolhidos de milhões de atletas, disponíveis publicamente. Estes dados são tratados de forma que é oferecida uma estimativa da sua capacidade atlética bem como uma previsão de como esta evoluirá. Ela pode ser acessada pelo utilizador na forma de relatórios e gráficos de fácil digestão. 
 
 A aplicação frontend foi feita na plataforma Flutter, tendo em vista que ela é multiplataforma e permite uma eventual expansão do escopo do projeto com alterações mínimas no source code. 
 
 Para a base da dados, foi utilizado MongoDB num container Docker com uma Flask API para realização das queries.
 
 ## Principais conclusões

  Podemos concluir com este projeto que a verficação de guias de exercício pode confortavelmente ser feita atarvés de  machine vision de forma automatizada quando as devidas precauções são tomadas, e.g. lidar com o obscurecimento de partes do corpo que normalmente são essenciais para pose estimation.
  
  A nossa aplicação, apesar de simples (dada as limitações de tempo e recurso), é facilmente escalável em função da nossas escolhas de arquitetura e abordagem. Graças ao Flutter, a aplicação pode ser utilizável em Desktop ou Web com mínimo esforço. O backend em Python pode correr em embedded system, e.g. microcomputadores. Julgamos ser uma aplicação bastante versátil para diferentes use cases. 
  
  Acreditamos que soluções como as que vos apresentamos têm o potêncial de causar um impacto social muito positivo, trazendo serviços de fitness coach para pessoas que normalmente não teriam acesso, criando oportunidades para os que mais precisam e ampliando a influência do desporto para uma vida mais saudável e atlética.
