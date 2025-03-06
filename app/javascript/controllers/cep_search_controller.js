import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cep-search"
export default class extends Controller {
  static targets = ['logradouro', 'bairro', 'cidade', 'estado']

  connect() {
    console.log("CEP Search Controller Connected");
  }

  fetchCep(event) {
    const cepInput = event.target;
    const cep = cepInput.value.replace(/\D/g, ''); // Remove any non-numeric characters

    if (cep.length !== 8) {
      console.log("CEP inválido. O CEP deve conter 8 dígitos.");
      return;
    }

    console.log(`Buscando CEP: ${cep}`);

    fetch(`https://viacep.com.br/ws/${cep}/json/`)
      .then(response => {
        if (!response.ok) {
          throw new Error("Erro na requisição do CEP");
        }
        return response.json();
      })
      .then(data => {
        if (data.erro) {
          console.error("CEP não encontrado");
          return;
        }

        console.log("Dados do CEP:", data);

        if (this.hasLogradouroTarget) this.logradouroTarget.value = data.logradouro;
        if (this.hasBairroTarget) this.bairroTarget.value = data.bairro;
        if (this.hasCidadeTarget) this.cidadeTarget.value = data.localidade;
        if (this.hasEstadoTarget) this.estadoTarget.value = data.uf;
      })
      .catch(error => {
        console.error("Erro ao buscar o CEP:", error);
      });
  }
}