library(testthat)

test_that("`args_js` returns correct output", {
  args <- args_js(a = "one", b = "two")

  expect_equal(args, ", a: 'one', b: 'two'")
})

test_that("`args_js` correctly remaps class to className", {
  args <- args_js(class = "my-class")

  expect_equal(args, ", class: 'my-class', className: 'my-class'")
})

test_that("`define_key` correctly defines a key", {
  key <- define_key("mykey")

  expect_equal(key, "cellInfo.row.mykey")
})

test_that("`define_key` correctly defines a key when key is null", {
  key <- define_key(NULL)

  expect_equal(key, paste(
    "cellInfo.row['.internal_uuid'] ?",
    "cellInfo.row['.internal_uuid'] :",
    "(Number(cellInfo.id) + 1)"
  ))
})

test_that("`dropdown_extra` sets choices to blank when length is 0", {
  choices <- build_dropdown_extra_choices(character(0))

  expect_equal(choices, "")
})

test_that("`dropdown_extra` serializes a single value as an array", {
  choices <- build_dropdown_extra_choices("a")

  expect_equal(choices, ', choices: ["a"]')
})

test_that("`dropdown_extra` sets choices correctly", {
  choices <- build_dropdown_extra_choices(letters[1:3])

  expect_equal(choices, ", choices: [\"a\",\"b\",\"c\"]")
})

test_that("expect tooltip to return JS_EVAL object", {
  expect_s3_class(tooltip_extra("This is my tool-tip", theme = "material"), "JS_EVAL")
})

test_that("expect inputs to return JS_EVAL object", {
  expect_s3_class(button_extra("button"), "JS_EVAL")
  expect_s3_class(checkbox_extra("checkbox"), "JS_EVAL")
  expect_s3_class(date_extra("date"), "JS_EVAL")
  expect_s3_class(dropdown_extra("dropdown", letters[1:3]), "JS_EVAL")
  expect_s3_class(text_extra("text"), "JS_EVAL")
  expect_s3_class(button_extra("button"), "JS_EVAL")
})
