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

