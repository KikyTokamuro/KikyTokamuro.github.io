const num2str = (n, forms) => {
  const n0 = Math.abs(n) % 100;
  const n1 = n0 % 10;

  if (n0 > 10 && n0 < 20) return forms[2];
  if (n1 > 1 && n1 < 5) return forms[1];
  if (n1 == 1) return forms[0];

  return forms[2];
}

const days = () => {
  const div = document.getElementById("dayslove");
  const days = moment().diff("2018-04-23", "days");
  const s = num2str(days, ["день", "дня", "дней"]);

  div.innerHTML = `Вместе уже ${days} ${s}!`;
}

days();
