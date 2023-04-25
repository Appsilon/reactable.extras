function ButtonExtras ({ id, label, className, children }) {
  const onClick = event => {
    Shiny.setInputValue(id, { row: children }, { priority: 'event' })
  }

  return React.createElement('button', { onClick, className }, label)
};

function checkboxExtras ({ id, value, children }) {
  const onChange = event => {
    Shiny.setInputValue(id, { row: children, value: event.target.checked }, { priority: 'event' })
  }

  return React.createElement('input', { type: 'checkbox', onChange, defaultChecked: value })
};

function dateExtras ({ id, value, children }) {
  const onChange = event => {
    Shiny.setInputValue(id, { row: children, value: event.target.value }, { priority: 'event' })
  }

  return React.createElement(
    'input',
    { type: 'date', onChange, defaultValue: value }
  )
};

function dropdownExtras ({ id, value, choices, selectClass, optionClass, children }) {
  const onChange = event => {
    Shiny.setInputValue(id, { row: children, value: event.target.value }, { priority: 'event' })
  }

  const items = choices.map((name) => {
    return React.createElement('option', { value: name, className: optionClass }, name)
  })

  return React.createElement(
    'select',
    { onChange, className: selectClass },
    items
  )
};
