//Vamos criar enum com os tipos de mensagens 

enum tipoMensagem: String {
  case promocao 
  case lembrete
  case alerta
}

struct Mensagem {
  var tipo: tipoMensagem
  var conteudo: String
}

//Enum para solicitações de alta prioridade

enum Prioridade{
  case baixa
  case media 
  case alta 
}

// Definindo o protocolo notificável 

protocol Notificavel {
  var mensagem: Mensagem {get set}
  var prioridade: Prioridade {get set}
  func enviarNotificacao()
}

extension Notificavel{
  func enviarNotificacao(){
    print("Enviando notificação...")
  }
}

//Aqui vamos criar o Struct representando um canal de notifcação por e-mail 

struct Email: Notificavel {
    var mensagem: Mensagem
    var prioridade: Prioridade
    var enderecoEmail: String

    func enviarNotificacao() {
        let tipoTexto = mensagem.tipo.rawValue
        let prefixo = prioridade == .alta ? "URGENTE ⚠️" : ""
        print("Enviando email para \(enderecoEmail): \(prefixo) [\(tipoTexto)] \(mensagem.conteudo)")
    }
}



//Continuidade dos demais Structs, de SMS e "Push Notification"

struct SMS: Notificavel {
    var mensagem: Mensagem
    var prioridade: Prioridade
    var numeroTelefone: String

    func enviarNotificacao() {
        let tipoTexto = mensagem.tipo.rawValue
        let prefixo = prioridade == .alta ? "URGENTE ⚠️" : ""
        print("Enviando SMS para \(numeroTelefone): \(prefixo) [\(tipoTexto)] \(mensagem.conteudo)")
    }
}


struct PushNotification: Notificavel {
    var mensagem: Mensagem
    var prioridade: Prioridade
    var tokenDispositivo: String

    func enviarNotificacao() {
        let tipoTexto = mensagem.tipo.rawValue
        let prefixo = prioridade == .alta ? "URGENTE ⚠️" : ""
        print("Enviando push para token \(tokenDispositivo): \(prefixo) [\(tipoTexto)] \(mensagem.conteudo)")
    }
}

//Implementação final - função para filtrar canais por tipo

func filtrarCanais<T: Notificavel>(de tipo: T.Type, em canais: [Notificavel]) -> [T] {
    return canais.compactMap { $0 as? T }
}




let msg1 = Mensagem(tipo: .promocao, conteudo: "Cupom de 20% OFF pra você!")
let msg2 = Mensagem(tipo: .lembrete, conteudo: "Não esqueça sua consulta amanhã.")
let msg3 = Mensagem(tipo: .alerta, conteudo: "Tentativa de login suspeita!")

let email = Email(mensagem: msg1, prioridade: .alta, enderecoEmail: "natan.advpr@gmail.com")
let sms = SMS(mensagem: msg2, prioridade: .media, numeroTelefone: "+5541988653982")
let push = PushNotification(mensagem: msg3, prioridade: .baixa, tokenDispositivo: "abc123xyz")


//Mais um struct que vai representar a mensagem
//Primeiro array com a finalidade de ter canais que irão seguir o protocolo Notificavel

let canais: [Notificavel] = [email, sms, push]

for canal in canais{
  canal.enviarNotificacao()
}

//Testando o filtro de canal escolhido

print("\n--- Filtrando apenas canais de Email ---\n")

let somenteEmails = filtrarCanais(de: Email.self, em: canais)

for email in somenteEmails {
    email.enviarNotificacao()
}

//observação, caso o professor solicite outros exemplos de filtragem como SMS e Push Notification segue o raciocónio comentado

// Exemplo: Filtrar apenas canais de SMS
// print("\n--- Filtrando apenas canais de SMS ---")
// let apenasSMS = filtrarCanais(de: SMS.self, em: canais)
// for sms in apenasSMS {
//     sms.enviarNotificacao()
// }

// Exemplo: Filtrar apenas canais de PushNotification
// print("\n--- Filtrando apenas canais de Push Notification ---")
// let apenasPush = filtrarCanais(de: PushNotification.self, em: canais)
// for push in apenasPush {
//     push.enviarNotificacao()
// }

