import { useState } from 'react'
import './dialogue.css'

function Dialogue() {
  console.log("Dialogue component loaded")
  const [count, setCount] = useState(0)
  const [dialogueOptions, setDialogueOption] = useState([])
  const [currentText, setCurrentText] = useState("Welcome traveler! How can I help you today?")
  const [speakerName, setSpeakerName] = useState("Friendly NPC")

  const handleMessage = (event) => {
    var data = event.data;

    if (data !== undefined && data.type === "hide") {
      document.getElementById('root').classList.add("hidden");
    }
    if (data !== undefined && data.type === "open") {
      console.log("Received data: ", data.text)
      setDialogueOption(data.options);
      setCurrentText(data.text);
      setSpeakerName(data.name);
      document.getElementById('root').classList.remove("hidden");
      
    }
  };

  window.addEventListener("message", handleMessage);

  return (
    <>
      <div className="container">        
        {/* Dialogue System */}
        <div className="dialogue-container">
          <h2>{speakerName}</h2>
          <div className="dialogue-text">
            <p>{currentText}</p>
          </div>
          <div className="dialogue-options">
            {dialogueOptions.map((option) => (
              <button 
                key={option.id}
                onClick={() => console.log(`Selected: ${option.label}`)}
                className="dialogue-button"
              >
                {option.label}
              </button>
            ))}
          </div>
        </div>
      </div>
    </>
  )
}

export default Dialogue
