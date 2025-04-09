const parseVariants = (code) => {
  // const variantGroupsRegex = /([a-z\-0-9:]+:)\((.*?)\)/g;
  // const variantGroupsRegex = /([a-z\-0-9\[\]\=:]+:)\((.*?)\)/g;
  const variantGroupsRegex = /([a-z0-9\[\]\=\&\_\\\/\@\#-:]+:)\((.*?)\)/g;
  
  const variantGroupMatches = [...code.matchAll(variantGroupsRegex)];

  variantGroupMatches.forEach(([ matchStr, variants, classes ]) => {
    const parsedClasses = classes
      .split(' ')
      .map((cls) => variants + cls)
      .join(' ');

    code = code.replace(matchStr, parsedClasses);
  });

  return code;
};

function twVariantGroups() {
  return {
    name: 'tw-variant-groups',
    transform(code) {
      const classNameRegex = /class\s*:\s*\"(.*?)\"/gm;
      const classNameMatches = [...code.matchAll(classNameRegex)].filter(
        (match) => match && match.length
      );
      classNameMatches.forEach(([ matchStr, className ]) => {
        const parsedClasses = parseVariants(className);

        code = code.replace(matchStr, `class: "${parsedClasses}"`);
      });

      return code;
    },
  };
}

export { parseVariants, twVariantGroups }