// test for checking select input inside the reactable
describe('Dropdown in reactable passes values to the shiny', () => {
  it('Dropdown', () => {
    cy.visit('http://localhost:8888');
    cy.get('.dropdown-extra').eq(1).select("Large").should('have.value', 'Large');
    cy.contains('Dropdown: {row : 2, value : Large, column : Type}');
  });
})

// test for checking checkbox input inside the reactable
describe('Checkbox in reactable passes values to the shiny', () => {
  it('Checkbox', () => {
    cy.visit('http://localhost:8888');
    cy.get('.checkbox-extra').eq(1).check().should('be.checked');
    cy.contains('Check: {row : 2, value : TRUE, column : Check');
  });
})

// test for checking date input inside the reactable
describe('Date in reactable passes values to the shiny', () => {
  it('Date', () => {
    cy.visit('http://localhost:8888');
    cy.get('.date-extra').eq(1).type('2020-01-01').should('have.value', '2020-01-01');
    cy.contains('Date: {row : 2, value : 2020-01-01, column : Date}');
  });
})

// test for checking text input inside the reactable
describe('Text Extra passes values to the Shiny App', () => {
    it('TextExtra', () => {
      cy.visit('http://localhost:8888');
      cy.get('.text-extra').eq(1).clear().type('new_value').should('have.value', 'new_value');
      cy.contains('Text: {row : id_2, value : new_value, column : Model}');
      // Click on body to trigger onBlur event
      cy.get('body').click();
      cy.contains('Text OnBlur: {row : id_2, value : new_value, column : Model}');
    });
  })
  
  