<div align="center">
  <img src="https://raw.githubusercontent.com/BrunoNFL/brunonfl.github.io/master/depictions/com.brunonfl.wicellswitcher/icon%403x.png" width="80" alt="Ícone do WiCellSwitcher">
  <h1>WiCellSwitcher</h1>
</div>

**Um utilitário inteligente para iPhones com jailbreak que gerencia automaticamente o Wi-Fi e os Dados Celulares para otimizar a vida útil da bateria.**

| Habilidades Principais Demonstradas |
| :--- |
| Internals do iOS & Engenharia Reversa |
| Objective-C & Manipulação de Runtime |
| Conhecimento Profundo de Frameworks (SpringBoard, CoreTelephony) |
| Arquitetura Orientada a Eventos & Gerenciamento de Recursos |
| Resolução de Problemas & Debugging de Sistemas Complexos |

---

## A História: Um Problema Pessoal, Uma Solução Pública

Nos primórdios do iOS, a duração da bateria era uma batalha constante. Notei que uma parte significativa do consumo de bateria do meu iPhone vinha dos rádios—especificamente, o Wi-Fi e os Dados Celulares ficarem ativos quando não eram necessários. O processo manual de alterná-los era tedioso e fácil de esquecer.

Eu acreditava que deveria haver uma maneira mais inteligente e automatizada. Essa frustração pessoal se tornou a motivação para o WiCellSwitcher: um *tweak* nascido de um problema do mundo real que visava criar uma solução "configure e esqueça" para usuários conscientes do consumo de bateria. Este projeto é um testemunho da ideia de que, se você tem um problema, muitas vezes tem o poder de projetar a solução você mesmo.

---

## Como Funciona: Um Mergulho Técnico Profundo

O WiCellSwitcher opera com uma **filosofia orientada a eventos**. Em vez de verificar ineficientemente o status do sistema a cada poucos segundos (o que anularia o propósito de economizar bateria), o tweak se conecta de forma inteligente a eventos específicos do sistema, executando código apenas quando ocorre uma mudança de estado relevante.

Isso foi alcançado através de engenharia reversa dos frameworks do iOS para encontrar os métodos privados e não documentados que sinalizam mudanças na conectividade.

### A Lógica Central é construída sobre três pilares principais:

1.  **Injeção Inicial:** O tweak primeiro injeta sua lógica na inicialização do dispositivo, fazendo um *hook* no SpringBoard:
    * `%hook SpringBoard` -> `- (void)applicationDidFinishLaunching:(id)application`
    Isso serve como o principal ponto de entrada para configurar todos os *listeners* e estados iniciais necessários.

2.  **Monitoramento do Estado do Wi-Fi:** Para reagir instantaneamente às mudanças de Wi-Fi (por exemplo, conectar-se a uma rede conhecida ou o usuário alterná-lo manualmente), o tweak se conecta diretamente ao `SBWiFiManager`:
    * `%hook SBWiFiManager`
        * `- (void)_powerStateDidChange`: Detecta quando o rádio Wi-Fi é ligado ou desligado.
        * `- (void)_linkDidChange`: Detecta quando o dispositivo se conecta ou desconecta de uma rede Wi-Fi.

3.  **O Truque Inteligente - Detectando Mudanças nos Dados Celulares:** Encontrar uma notificação privada e confiável para as mudanças de estado dos dados celulares foi um grande desafio. A solução foi indireta, mas altamente eficaz: escutar o evento de atualização da UI para o ícone na barra de status.
    * `%hook SBStatusBarStateAggregator` -> `- (void)_updateDataNetworkItem`
    Este método é chamado pelo sistema toda vez que o ícone de dados celulares (LTE, 4G, 3G) precisa ser atualizado. Ao fazer um *hook* nisso, pude criar minha própria notificação confiável e acionar minha lógica personalizada, que foi cuidadosamente injetada na classe `SBWiFiManager` para manter o código do tweak autocontido.

---

## Desafios do Desenvolvimento: O Rito de Passagem do Loop Infinito

Nenhum projeto de engenharia reversa acontece sem dificuldades. As primeiras versões do WiCellSwitcher foram atormentadas por travamentos e loops recursivos, especialmente ao manipular os dados celulares.

Um desafio clássico foi criar uma situação onde:
1. O tweak desativava os dados celulares.
2. O sistema disparava uma notificação sobre a mudança de estado.
3. O tweak capturava essa notificação e, com base em sua lógica, tentava alterar o estado novamente... *ad infinitum*.

Depurar esses loops—e me ver temporariamente sem poder alterar minhas próprias configurações de celular—foi uma parte crucial do processo de desenvolvimento. Isso reforçou a importância de um gerenciamento de estado cuidadoso e da criação de verificações para impedir que o tweak reagisse às suas próprias ações. Superar esse obstáculo foi um passo significativo para tornar o utilitário estável e confiável.

---

## Uma Breve Introdução ao Desenvolvimento de Tweaks

Para aqueles que são novos neste mundo, este projeto foi construído usando as ferramentas padrão da comunidade jailbreak:

* **Theos:** Uma cadeia de ferramentas de desenvolvimento flexível para criar tweaks.
* **Logos:** Uma sintaxe de pré-processamento que torna o *hooking* em métodos Objective-C incrivelmente simples e legível (por exemplo, a sintaxe `%hook`, `%orig` e `%end` que você vê acima).
* **Hooking:** O conceito central de interceptar uma chamada de função (neste caso, um método Objective-C) e executar seu próprio código antes, depois ou em vez da função original.

Este projeto é um exemplo perfeito de como essas ferramentas podem ser usadas para estender e modificar a funcionalidade de um sistema operacional de código fechado como o iOS, tudo para resolver um problema tangível.

---

## Reconhecimento da Comunidade 🏆

O WiCellSwitcher foi calorosamente recebido pela comunidade jailbreak, ganhando feedback positivo e um destaque em um grande portal de notícias sobre iOS.

* **Destaque no iDownloadBlog:** Leia a análise oficial do tweak no **[iDownloadBlog](https://www.idownloadblog.com/2019/05/01/wicellswitcher/)**.
* **Lançamento Original no Reddit:** Veja a reação da comunidade no **[subreddit r/jailbreak](https://www.reddit.com/r/jailbreak/comments/bjca1y/release_wicellswitcher_switch_between_wifi_and/)**.

### O Que os Usuários Disseram

Aqui estão alguns comentários do tópico de lançamento original:

> "THIS is what i need. God i love this. I didnt realize my phone used my cell data when i was connected to wifi. Thats some shit."
>
> — *u/CrucifictionGod on r/jailbreak*

> "Work Perfect in A12 , thanks by this Awesome Tweak!!!"
>
> — *u/yosbel182us on r/jailbreak*

---

## Como Compilar

1.  Certifique-se de ter a [toolchain Theos](https://theos.dev/) instalada.
2.  Clone o repositório: `git clone https://github.com/BrunoNFL/WiCellSwitcher.git`
3.  Navegue para o diretório do projeto: `cd WiCellSwitcher`
4.  Execute o comando make: `make package`

Isso produzirá um arquivo `.deb` que pode ser instalado em um dispositivo com jailbreak.
