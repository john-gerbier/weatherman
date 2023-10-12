import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["autocomplete", "suggestionList"]
  
  connect() {
    this.previousSearchTerm = ''
    this.debounceTimer = null
  }

  input(event) {
    const searchTerm = this.autocompleteTarget.value

    if (searchTerm.length < 3 || searchTerm === this.previousSearchTerm) { return }  // validating before calling api
    
    this.previousSearchTerm = searchTerm

    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
    }

    this.debounceTimer = setTimeout(() => {  // debouncing for concurrent requests
      this.fetchSuggestions(searchTerm)
    }, 300);
  }

  fetchSuggestions(searchTerm) {
    fetch(`https://nominatim.openstreetmap.org/search?q=${searchTerm}&format=json`)
      .then((response) => response.json())
      .then((data) => {
        const suggestions = data.map((item) => item.display_name)
        this.displaySuggestions(suggestions)
      })
      .catch((error) => {
        console.error("Error fetching data:", error)
      })
  }

  displaySuggestions(suggestions) {
    this.suggestionListTarget.innerHTML = ''
    
    suggestions.forEach((suggestion) => {
      const suggestionItem = document.createElement("li")
      suggestionItem.className = 'hover:bg-teal-400 m-1'  // dynamic element styling
      suggestionItem.textContent = suggestion
      
      suggestionItem.addEventListener("click", () => {
        this.autocompleteTarget.value = suggestion
        this.suggestionListTarget.innerHTML = ''
      })
      
      this.suggestionListTarget.appendChild(suggestionItem)
    })
  }
}
