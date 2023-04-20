function ButtonExtras({ id, label, children }) {
    const onClick = event => {
      console.log("button")
      console.log(event.target.value)
      Shiny.setInputValue(id, { row: children}, { priority: "event" })
    }
    return React.createElement("button", { onClick }, label)
  };

function checkboxExtras({ id, value, children }) {
    const onChange = event => {
      console.log("check")
      console.log(event.target.checked)
      Shiny.setInputValue(id, { row: children, value: event.target.checked}, { priority: "event" })
    }
    return React.createElement(
    "input",
    { type: "checkbox", onChange: onChange, defaultChecked: value}
  );
};

function dateExtras({ id, value, children }) {
    console.log(value)
    console.log(typeof value)
    const onChange = event => {
      Shiny.setInputValue(id, { row: children, value:  event.target.value}, { priority: "event" })
    }

    return React.createElement(
    "input",
    { type: "date", onChange: onChange, defaultValue: value}
  );
};

