import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../theme/glass_morphism.dart';
import '../widgets/status_bar.dart';
import '../models/mock_data.dart';

class SequencesScreen extends StatefulWidget {
  const SequencesScreen({super.key});

  @override
  State<SequencesScreen> createState() => _SequencesScreenState();
}

class _SequencesScreenState extends State<SequencesScreen> {
  String? _playingId;
  double _playbackProgress = 0;

  String _formatDuration(Duration d) {
    if (d.inMinutes > 0) {
      return '${d.inMinutes}m ${d.inSeconds.remainder(60)}s';
    }
    return '${d.inSeconds}s';
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${d.day}.${d.month}.${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          children: [
            GimbalStatusBar(state: MockData.connectedGimbal)
                .animate()
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 20),

            // Header
            Row(
              children: [
                const Text(
                  'MOTION SEQUENCES',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 4,
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                GlassContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  borderRadius: 10,
                  opacity: 0.1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.folder_outlined,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${MockData.sequences.length}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            const SizedBox(height: 16),

            // Sequence list
            Expanded(
              child: ListView.builder(
                itemCount: MockData.sequences.length,
                itemBuilder: (context, index) {
                  final seq = MockData.sequences[index];
                  final isPlaying = _playingId == seq.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _SequenceCard(
                      sequence: seq,
                      isPlaying: isPlaying,
                      progress: isPlaying ? _playbackProgress : 0,
                      onPlay: () {
                        setState(() {
                          if (_playingId == seq.id) {
                            _playingId = null;
                          } else {
                            _playingId = seq.id;
                            _playbackProgress = 0.35;
                          }
                        });
                      },
                      formatDuration: _formatDuration,
                      formatDate: _formatDate,
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 400.ms,
                        delay: Duration(milliseconds: 150 + index * 80),
                      )
                      .slideX(begin: 0.05);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SequenceCard extends StatelessWidget {
  final MotionSequence sequence;
  final bool isPlaying;
  final double progress;
  final VoidCallback onPlay;
  final String Function(Duration) formatDuration;
  final String Function(DateTime) formatDate;

  const _SequenceCard({
    required this.sequence,
    required this.isPlaying,
    required this.progress,
    required this.onPlay,
    required this.formatDuration,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      borderRadius: 16,
      opacity: isPlaying ? 0.15 : 0.08,
      border: Border.all(
        color: isPlaying
            ? AppColors.accentCyan.withValues(alpha: 0.4)
            : AppColors.glassBorder,
        width: isPlaying ? 1.5 : 1,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Play button
                GestureDetector(
                  onTap: onPlay,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isPlaying
                          ? AppColors.primaryGradient
                          : null,
                      color: isPlaying
                          ? null
                          : Colors.white.withValues(alpha: 0.06),
                      border: Border.all(
                        color: isPlaying
                            ? Colors.transparent
                            : AppColors.glassBorder,
                      ),
                      boxShadow: isPlaying
                          ? [
                              BoxShadow(
                                color: AppColors.accentCyan.withValues(alpha: 0.3),
                                blurRadius: 12,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: isPlaying
                          ? Colors.white
                          : AppColors.textSecondary,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              sequence.name,
                              style: TextStyle(
                                color: isPlaying
                                    ? AppColors.accentCyan
                                    : AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (sequence.isFavorite)
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.warning,
                              size: 16,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _Tag(
                            icon: Icons.access_time,
                            label: formatDuration(sequence.duration),
                          ),
                          const SizedBox(width: 8),
                          _Tag(
                            icon: Icons.grain,
                            label: '${sequence.pointCount} pts',
                          ),
                          const SizedBox(width: 8),
                          _Tag(
                            icon: Icons.calendar_today,
                            label: formatDate(sequence.createdAt),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // More button
                GlassIconButton(
                  icon: Icons.more_vert,
                  size: 36,
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Progress bar
          if (isPlaying)
            Container(
              height: 3,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                color: Colors.white.withValues(alpha: 0.03),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Tag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: AppColors.textMuted),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
