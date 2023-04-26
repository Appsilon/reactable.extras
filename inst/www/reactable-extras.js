function ButtonExtras ({ id, label, className, children }) {
  const onClick = event => {
    Shiny.setInputValue(id, { row: children }, { priority: 'event' })
  }

  return React.createElement('button', { onClick, className }, label)
};

function checkboxExtras ({ id, value, className, children }) {
  const onChange = event => {
    Shiny.setInputValue(id, { row: children, value: event.target.checked }, { priority: 'event' })
  }

  return React.createElement('input', { type: 'checkbox', defaultChecked: value,  className, onChange })
};

function dateExtras ({ id, value, className, children }) {
  const onChange = event => {
    Shiny.setInputValue(id, { row: children, value: event.target.value }, { priority: 'event' })
  }

  return React.createElement(
    'input',
    { type: 'date', defaultValue: value, onChange, className}
  )
};

function dropdownExtras ({ id, value, choices, className, children }) {
  const onChange = event => {
    Shiny.setInputValue(id, { row: children, value: event.target.value }, { priority: 'event' })
  }

  const items = choices.map((name) => {
    return React.createElement('option', { value: name }, name)
  })

  return React.createElement(
    'select',
    { onChange, className },
    items
  )
};

function textExtras ({ id, value, className, children }) {
  const onChange = event => {
    Shiny.setInputValue(id, { row: children, value: event.target.value }, { priority: 'event' })
  }

  return React.createElement(
    'input',
    { onChange, className, defaultValue: value }
  )
};
