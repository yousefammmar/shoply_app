part of '../signup_screen.dart';

class _SingupHeader extends StatelessWidget {
  const _SingupHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          context.l10n.joinUs,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: cs.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 20),
        BlocBuilder<SignupCubit, SignupState>(
          buildWhen: (previous, current) {
            return current is SingupPickImageState ||
                current is SingupRemoveImageState;
          },
          builder: (context, state) {
            final cubit = context.read<SignupCubit>();
            return Stack(
              alignment: AlignmentGeometry.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      cubit.image == null || (cubit.image?.path.isEmpty ?? true)
                      ? NetworkImage(AppImages.profilePicture)
                      : FileImage(cubit.image!),
                ),
                PositionedDirectional(
                  bottom: 5,
                  end: 5,
                  child: GestureDetector(
                    onTap: () {
                      cubit.pickImage();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.primary,
                      ),
                      child: Icon(
                        Icons.camera_alt_sharp,
                        color: cs.onPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                cubit.image == null || (cubit.image?.path.isEmpty ?? true)
                    ? SizedBox.shrink()
                    : PositionedDirectional(
                        bottom: 5,
                        start: 5,
                        child: GestureDetector(
                          onTap: () {
                            cubit.deleteImage();
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cs.error,
                            ),
                            child: Icon(
                              Icons.delete,
                              color: cs.onError,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
      ],
    );
  }
}
