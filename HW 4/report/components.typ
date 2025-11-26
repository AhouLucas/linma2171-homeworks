#let default-color = rgb(100, 100, 100)

#let frame(content, counter: none, title: none, fill-body: none, fill-header: none, radius: 0.2em) = {
  let header = none

  if fill-header == none and fill-body == none {
    fill-header = default-color.lighten(75%)
    fill-body = default-color.lighten(85%)
  }
  else if fill-header == none {
    fill-header = fill-body.darken(10%)
  }
  else if fill-body == none {
    fill-body = fill-header.lighten(50%)
  }

  if radius == none {
    radius = 0pt
  }

  if counter == none and title != none {
    header = [*#title*]
  } else if counter != none and title == none {
    header = [*#counter*]
  } else {
    header = [*#counter:* #title]
  }

  show stack: set block(breakable: false, above: 0.8em, below: 0.5em)

  stack(
    block(
      width: 100%,
      inset: (x: 0.4em, top: 0.35em, bottom: 0.45em),
      fill: fill-header,
      radius: (top: radius, bottom: 0cm),
      header,
    ),
    block(
      width: 100%,
      inset: (x: 0.4em, top: 0.35em, bottom: 0.45em),
      fill: fill-body,
      radius: (top: 0cm, bottom: radius),
      content,
    ),
  )
}

#let d = counter("definition")
#let definition(content, title: none, ..options) = {
  d.step()
  frame(
    counter: context d.display(x => "Definition " + str(x)),
    title: title,
    content,
    ..options,
  )
}

#let t = counter("theorem")
#let theorem(content, title: none, ..options) = {
  t.step()
  frame(
    counter: context t.display(x => "Theorem " + str(x)),
    title: title,
    content,
    ..options,
  )
}

#let l = counter("lemma")
#let lemma(content, title: none, ..options) = {
  l.step()
  frame(
    counter: context l.display(x => "Lemma " + str(x)),
    title: title,
    content,
    ..options,
  )
}

#let c = counter("corollary")
#let corollary(content, title: none, ..options) = {
  c.step()
  frame(
    counter: context c.display(x => "Corollary " + str(x)),
    title: title,
    content,
    ..options,
  )
}

#let a = counter("algorithm")
#let algorithm(content, title: none, ..options) = {
  a.step()
  frame(
    counter: context a.display(x => "Algorithm " + str(x)),
    title: title,
    content,
    ..options,
  )
}

#let p = counter("proposition")
#let proposition(content, title: none, ..options) = {
  p.step()
  frame(
    counter: context p.display(x => "Proposition " + str(x)),
    title: title,
    content,
    ..options,
  )
}

#let e = counter("example")
#let example(content, title: none, ..options) = {
  e.step()
  frame(
    counter: context e.display(x => "Example " + str(x)),
    title: title,
    content,
    ..options,
  )
}

#let answer(content, title: none, ..options) = {
  frame(
    counter: none,
    title: title,
    content,
    ..options,
  )
}