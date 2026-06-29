
                self.p_enums(contract.enums)
            elif item == Item.STRUCT:
                self.p_structs(contract.structs)
            elif item == Item.FUNCTION:
                self.p_functions(contract.cheatcodes)
            else:
                assert False, f"unknown item {item}"

    def p_prelude(self, contract: Cheatcodes | None = None):
        self._p_str(f"// SPDX-License-Identifier: {self.spdx_identifier}")
        self._p_nl()

        if self.solidity_requirement != "":
            req = self.solidity_requirement
        else:
            req = ">=0.8.13 <0.9.0"
        self._p_str(f"pragma solidity {req};")
        self._p_nl()

        self._p_nl()

    def p_errors(self, errors: list[Error]):
        for error in errors:
            self._p_line(lambda: self.p_error(error))

    def p_error(self, error: Error):
        self._p_comment(error.description, doc=True)
        self._p_line(lambda: self._p_str(error.declaration))

    def p_events(self, events: list[Event]):
        for event in events:
            self._p_line(lambda: self.p_event(event))

    def p_event(self, event: Event):
        self._p_comment(event.description, doc=True)
        self._p_line(lambda: self._p_str(event.declaration))

    def p_enums(self, enums: list[Enum]):
        for enum in enums:
            self._p_line(lambda: self.p_enum(enum))

    def p_enum(self, enum: Enum):
        self._p_comment(enum.description, doc=True)
        self._p_line(lambda: self._p_str(f"enum {enum.name} {{"))
        self._with_indent(lambda: self.p_enum_variants(enum.variants))
        self._p_line(lambda: self._p_str("}"))

    def p_enum_variants(self, variants: list[EnumVariant]):
        for i, variant in enumerate(variants):
            self._p_indent()
            self._p_comment(variant.description)

            self._p_indent()
            self._p_str(variant.name)
            if i < len(variants) - 1:
                self._p_str(",")
            self._p_nl()

    def p_structs(self, structs: list[Struct]):
        for struct in structs:
            self._p_line(lambda: self.p_struct(struct))

    def p_struct(self, struct: Struct):
        self._p_comment(struct.description, doc=True)
        self._p_line(lambda: self._p_str(f"struct {struct.name} {{"))
        self._with_indent(lambda: self.p_struct_fields(struct.fields))
        self._p_line(lambda: self._p_str("}"))

    def p_struct_fields(self, fields: list[StructField]):
        for field in fields:
            self._p_line(lambda: self.p_struct_field(field))

    def p_struct_field(self, field: StructField):
        self._p_comment(field.description)
        self._p_indented(lambda: self._p_str(f"{field.ty} {field.name};"))

    def p_functions(self, cheatcodes: list[Cheatcode]):
        for cheatcode in cheatcodes:
            self._p_line(lambda: self.p_function(cheatcode.func))

    def p_function(self, func: Function):
        self._p_comment(func.description, doc=True)
        self._p_line(lambda: self._p_str(func.declaration))

    def _p_comment(self, s: str, doc: bool = False):
        s = s.strip()
        if s == "":
            return

        s = map(lambda line: line.lstrip(), s.split("\n"))
        if self.block_doc_style:
            self._p_str("/*")
            if doc:
                self._p_str("*")
            self._p_nl()
            for line in s:
                self._p_indent()
                self._p_str(" ")
                if doc:
                    self._p_str("* ")
                self._p_str(line)
                self._p_nl()
            self._p_indent()
            self._p_str(" */")
            self._p_nl()
        else:
            first_line = True
            for line in s:
                if not first_line:
                    self._p_indent()
                first_line = False

                if doc:
                    self._p_str("/// ")
                else:
                    self._p_str("// ")
                self._p_str(line)
                self._p_nl()

    def _with_indent(self, f: VoidFn):
        self._inc_indent()
        f()
        self._dec_indent()

    def _p_line(self, f: VoidFn):
        self._p_indent()
        f()
        self._p_nl()

    def _p_indented(self, f: VoidFn):
        self._p_indent()
        f()

    def _p_indent(self):
        for _ in range(self.indent_level):
            self._p_str(self._indent_str)

    def _p_nl(self):
        self._p_str(self.nl_str)

    def _p_str(self, txt: str):
        self.buffer += txt

    def _inc_indent(self):
        self.indent_level += 1

    def _dec_indent(self):
        self.indent_level -= 1


if __name__ == "__main__":
    main()
