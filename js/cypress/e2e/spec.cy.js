// test for checking select input inside the reactable
describe('Dropdown in reactable passes values to the shiny', () => {
  it('Dropdown', () => {
    cy.visit('http://localhost:8888');
    cy.get('.dropdown-extra').eq(1).select("yui").should('have.value', 'yui');
    cy.contains('Dropdown: {row : 1, value : yui}');
  });
})

// test for checking checkbox input inside the reactable
describe('Checkbox in reactable passes values to the shiny', () => {
  it('Checkbox', () => {
    cy.visit('http://localhost:8888');
    cy.get('.checkbox-extra').eq(1).check().should('be.checked');
    cy.contains('Check: {row : 1, value : TRUE}');
  });
})

// test for checking date input inside the reactable
describe('Date in reactable passes values to the shiny', () => {
  it('Date', () => {
    cy.visit('http://localhost:8888');
    cy.get('.date-extra').eq(1).type('2020-01-01').should('have.value', '2020-01-01');
    cy.contains('Date: {row : 1, value : 2020-01-01}');
  });
})