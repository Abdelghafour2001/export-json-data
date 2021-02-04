var main = document.getElementById("display-area");
////get method /all
function displayAll(){
    $(document).ready(function(){
        $.getJSON("/all/data.json", function(data){
          for(var x in data.books)
          {
              var book = document.createElement('span');
              book.className="book";
              var pic= document.createElement('img');
              pic.src=data.books[x].poster;
              pic.alt="poster";
              book.appendChild(pic);
              var titre = document.createElement('h4');
              titre.innerText=data.books[x].titre;
            book.appendChild(titre);
            var datex = document.createElement('p');
            datex.innerText="Date de sortie :"+data.books[x].date;
            book.appendChild(datex);
            main.appendChild(book);
          }
        }).fail(function(){
            alert("An error has occurred.");
        });
    });
}
displayAll();//ou bien onload=("displayAll();")
//////passage de parametre name pour /search
var btnrech = document.getElementById("btn-rech");
btnrech.addEventListener("click",function displayByName(){
  var rechinput=document.getElementById("search_bar");
  var name= rechinput.value; 
  $("#display-area").empty();
  $(document).ready(function(){
       $("#btn-rech").click(function(event){
        $.getJSON("/search/data.json",name,function(data){
          for(var y in data.books){
            var para = data.books[y].titre.toString().toLowerCase().split(" ");

            ////if name passé en parametre exist dans json donc l afficher
            if(para.includes(name.toString().toLowerCase())){
             var book = document.createElement('span');
              book.className="book";
              var pic= document.createElement('img');
              pic.src=data.books[y].poster;
              pic.alt="poster";
              book.appendChild(pic);
              var titre = document.createElement('h4');
              titre.innerText=data.books[y].titre;
            book.appendChild(titre);
            var datex = document.createElement('p');
            datex.innerText="Date de sortie :"+data.books[y].date;
            book.appendChild(datex);
            main.appendChild(book);
          }}
        }).fail(function(){
            alert("An error has occurred.");
        });
      });
    });
});