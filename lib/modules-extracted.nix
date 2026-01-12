# https://github.com/NixOS/nixpkgs/blob/a5cfe012401cfebb4b2c28e74857b8ffe1402b4b/lib/modules.nix
/*
Copyright (c) 2003-2026 Eelco Dolstra and the Nixpkgs/NixOS contributors

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
{ lib }:
with lib.modules;
let
  inherit (lib)
    addErrorContext
    all
    any
    attrByPath
    attrNames
    catAttrs
    concatLists
    concatMap
    concatStringsSep
    elem
    filter
    foldl'
    functionArgs
    getAttrFromPath
    genericClosure
    head
    id
    imap1
    isAttrs
    isBool
    isFunction
    isInOldestRelease
    isList
    isString
    length
    mapAttrs
    mapAttrsToList
    mapAttrsRecursiveCond
    min
    optional
    optionalAttrs
    optionalString
    recursiveUpdate
    reverseList
    sort
    seq
    setAttrByPath
    substring
    throwIfNot
    trace
    typeOf
    types
    unsafeGetAttrPos
    warn
    warnIf
    zipAttrs
    zipAttrsWith
    ;
  inherit (lib.options)
    isOption
    mkOption
    showDefs
    showFiles
    showOption
    unknownModule
    ;
  inherit (lib.strings)
    isConvertibleWithToString
    ;

  unifyModuleSyntax =
    file: key: m:
    let
      addMeta =
        config:
        if m ? meta then
          mkMerge [
            config
            { meta = m.meta; }
          ]
        else
          config;
      addFreeformType =
        config:
        if m ? freeformType then
          mkMerge [
            config
            { _module.freeformType = m.freeformType; }
          ]
        else
          config;
    in
    if m ? config || m ? options then
      let
        badAttrs = removeAttrs m [
          "_class"
          "_file"
          "key"
          "disabledModules"
          "imports"
          "options"
          "config"
          "meta"
          "freeformType"
        ];
      in
      if badAttrs != { } then
        throw "Module `${key}' has an unsupported attribute `${head (attrNames badAttrs)}'. This is caused by introducing a top-level `config' or `options' attribute. Add configuration attributes immediately on the top level instead, or move all of them (namely: ${toString (attrNames badAttrs)}) into the explicit `config' attribute."
      else
        {
          _file = toString m._file or file;
          _class = m._class or null;
          key = toString m.key or key;
          disabledModules = m.disabledModules or [ ];
          imports = m.imports or [ ];
          options = m.options or { };
          config = addFreeformType (addMeta (m.config or { }));
        }
    else
      # shorthand syntax
      throwIfNot (isAttrs m) "module ${file} (${key}) does not look like a module." {
        _file = toString m._file or file;
        _class = m._class or null;
        key = toString m.key or key;
        disabledModules = m.disabledModules or [ ];
        imports = m.require or [ ] ++ m.imports or [ ];
        options = { };
        config = addFreeformType (
          removeAttrs m [
            "_class"
            "_file"
            "key"
            "disabledModules"
            "require"
            "imports"
            "freeformType"
          ]
        );
      };

in
{
  inherit unifyModuleSyntax;
}
