memory = {};

function tryFromMemory (id, uuid, column, value) {
  let mem_value = memory[[id, uuid, column]];
  return mem_value ? mem_value : value;
}

function updateMemory (id, uuid, column, value) {
  memory[[id, uuid, column]] = value;
}

let ReRenderCount = 0;

function GenerateTooltipId () {
  return "tooltip-" + ReRenderCount++;
}

function TooltipExtras ({ column, tooltip, theme }) {
  const tooltip_id = GenerateTooltipId();
  React.useEffect(() => {
    tippy("#" + tooltip_id, { content: tooltip, theme: theme });
  }, []);
  return React.createElement(
    'span',
    { id: tooltip_id },
    column
  )
}

function ButtonExtras ({ id, label, uuid, column, className, children }) {
  const onClick = event => {
    Shiny.setInputValue(id, { row: uuid, column: column}, { priority: 'event' })
  }

  return React.createElement('button', { onClick, className, key: uuid }, label)
};

function checkboxExtras ({ id, value, uuid, column, className, children }) {

  value = tryFromMemory(id, uuid, column, value);

  const onChange = event => {
    updateMemory(id, uuid, column, event.target.checked);
    Shiny.setInputValue(id, { row: uuid, value: event.target.checked, column: column }, { priority: 'event' })
  }

  return React.createElement('input', { type: 'checkbox', key: uuid, defaultChecked: value, className, onChange })
};

function dateExtras ({ id, value, uuid, column, className, children }) {

  value = tryFromMemory(id, uuid, column, value);

  const onChange = event => {
    updateMemory(id, uuid, column, event.target.value);
    Shiny.setInputValue(id, { row: uuid, value: event.target.value, column: column }, { priority: 'event' })
  }

  return React.createElement(
    'input',
    { type: 'date', key: uuid, defaultValue: value, onChange, className }
  )
};

function dropdownExtras ({ id, value, uuid, column, choices, className, children }) {

  value = tryFromMemory(id, uuid, column, value);

  const onChange = event => {
    updateMemory(id, uuid, column, event.target.value);
    Shiny.setInputValue(id, { row: uuid, value: event.target.value, column: column }, { priority: 'event' })
  }

  const items = choices.map((name) => {
    return React.createElement('option', { value: name }, name)
  })

  return React.createElement(
    'select',
    { onChange, className, key: uuid, defaultValue: value },
    items
  )
};

function textExtras ({ id, value, uuid, column, page, className, children }) {

  value = tryFromMemory(id, uuid, column, value);

  const onInput = event => {
    updateMemory(id, uuid, column, event.target.value);
    Shiny.setInputValue(id, { row: uuid, value: event.target.value, column: column }, { priority: 'event' })
  }

  return React.createElement(
    'input',
    { onInput, className, defaultValue: value, key: uuid }
  )
};

